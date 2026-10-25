import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prayer_wall/app/app.dart';
import 'package:prayer_wall/core/store.dart';
import 'package:prayer_wall/features/personal_widgets.dart';
import 'package:prayer_wall/core/widgets.dart';
import 'package:prayer_wall/features/home.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final pair in [('Outfit', 'Outfit'), ('DM Sans', 'DMSans')]) {
      await (FontLoader(pair.$1)
            ..addFont(rootBundle.load('assets/fonts/${pair.$2}.ttf')))
          .load();
    }
  });
  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    SharedPreferences.setMockInitialValues({});
  });
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });
  test(
      'Completion, editing, answer and widget selection persist with stable identity',
      () async {
    final store = PrayerStore();
    await store.load();
    await store.changePrayer('add', item: const PrayerItem('1', 'Family'));
    await store.changePrayer('toggle', id: '1');
    await store.changePrayer('edit',
        id: '1', item: const PrayerItem('1', 'Peace for my family'));
    expect(store.prayers.single.id, '1');
    expect(store.prayers.single.done, true);
    expect(store.prayers.single.answered, false);
    final restored = PrayerStore();
    await restored.load();
    expect(restored.prayers.single.title, 'Peace for my family');
    await restored.changePrayer('toggle', id: '1');
    expect(restored.prayers.single.done, false);
    await restored.changePrayer('answer', id: '1');
    await restored.changePrayer('pin', id: '1');
    expect(restored.prayers.single.answered, true);
    expect(restored.prayers.single.pinned, false);
    await restored.changePrayer('delete', id: '1');
    expect(restored.prayers, isEmpty);
    store.dispose();
    restored.dispose();
  });
  test('Rapid additions and reloads serialize without losing prayers',
      () async {
    final store = PrayerStore();
    await store.load();
    await Future.wait([
      store.changePrayer('add', item: const PrayerItem('a', 'Family')),
      store.load(),
      store.changePrayer('add', item: const PrayerItem('b', 'Friends'))
    ]);
    expect(store.prayers.map((p) => p.id), ['a', 'b']);
    expect(
        await store.changePrayer('add', item: const PrayerItem('empty', '   ')),
        false);
    expect(store.prayers.length, 2);
    expect(await store.changePrayer('toggle', id: 'a'), true);
    expect(store.error, isNull);
    store.dispose();
  });
  test('A previous local day is not complete today', () {
    final yesterday = DateTime.now()
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .substring(0, 10);
    expect(PrayerItem('1', 'Hope', date: yesterday).done, false);
  });
  test(
      'Journal migration preserves strings, order, stable IDs and unknown dates',
      () async {
    SharedPreferences.setMockInitialValues({
      'journal': ['An old reflection', 'Another thought']
    });
    final store = PrayerStore();
    await store.load();
    expect(store.journal.first.createdAt, isNull);
    expect(store.journal.map((e) => e.body),
        ['An old reflection', 'Another thought']);
    final entry = store.journal.first;
    await store.saveJournal('Edited reflection', entry: entry);
    final restored = PrayerStore();
    await restored.load();
    expect(restored.journal.first.id, entry.id);
    expect(restored.journal.first.createdAt, isNull);
    expect(restored.journal.first.updatedAt, isNotNull);
    expect(restored.journal.first.body, 'Edited reflection');
    expect(
        (await SharedPreferences.getInstance()).getStringList('journal')!.first,
        'An old reflection');
    await restored.deleteJournal(entry.id);
    expect(restored.journal.length, 1);
    expect(
        (await SharedPreferences.getInstance()).containsKey('journal'), false);
    expect(jsonDecode(restored.exportData())['journal'].length, 1);
    store.dispose();
    restored.dispose();
  });
  test('Corrupt saved content cannot be overwritten by a new prayer', () async {
    SharedPreferences.setMockInitialValues({'prayers': 'not valid json'});
    final store = PrayerStore();
    await store.load();
    expect(store.loadFailed, true);
    expect(await store.changePrayer('add', item: const PrayerItem('a', 'Hope')),
        false);
    expect((await SharedPreferences.getInstance()).getString('prayers'),
        'not valid json');
    store.dispose();
  });
  test('Native save failure retains state and later retry can succeed',
      () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    bool fail = false;
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(widgetChannel, (call) async {
      if (fail) throw PlatformException(code: 'storage');
      return call.method == 'load' ? '[]' : '[{"id":"a","title":"Hope"}]';
    });
    final store = PrayerStore();
    await store.load();
    fail = true;
    expect(await store.changePrayer('add', item: const PrayerItem('a', 'Hope')),
        false);
    expect(store.prayers, isEmpty);
    fail = false;
    expect(await store.changePrayer('add', item: const PrayerItem('a', 'Hope')),
        true);
    expect(store.prayers.single.title, 'Hope');
    messenger.setMockMethodCallHandler(widgetChannel, null);
    store.dispose();
  });
  Future<void> launch(WidgetTester tester, Size size,
      {double scale = 1}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(ProviderScope(
        child: MediaQuery(
            data: MediaQueryData(
                size: size,
                textScaler: TextScaler.linear(scale),
                disableAnimations: tester.platformDispatcher
                    .accessibilityFeatures.disableAnimations),
            child: const PrayerWallApp())));
    await tester.pumpAndSettle();
  }

  testWidgets(
      'Phone user adds a prayer and checks it in the live widget preview',
      (tester) async {
    await launch(tester, const Size(430, 932));
    await tester.tap(find.byTooltip('Prayers').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add prayer').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Peace for my family');
    await tester.tap(find.text('Add prayer').last);
    await tester.pumpAndSettle();
    expect(find.text('Peace for my family'), findsNWidgets(2));
    final checkbox = find.descendant(
        of: find.byType(WidgetPreview), matching: find.byType(Checkbox));
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);
    await tester.pumpAndSettle();
    expect(
        tester
            .widgetList<Checkbox>(find.byType(Checkbox))
            .every((c) => c.value == true),
        true);
    expect(find.text('Prayed today'), findsNWidgets(2));
    final options = find.byTooltip('Prayer options');
    await tester.ensureVisible(options);
    await tester.tap(options);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit prayer'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Care for our neighbors');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(find.text('Care for our neighbors'), findsNWidgets(2));
    expect(
        tester
            .widgetList<Checkbox>(find.byType(Checkbox))
            .every((c) => c.value == true),
        true);

    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    debugDefaultTargetPlatformOverride = null;
  });
  testWidgets('Wall filters and reversible sample prayer counts work',
      (tester) async {
    await launch(tester, const Size(1440, 1000));
    await tester.tap(find.byTooltip('Wall'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Peace').first);
    await tester.pumpAndSettle();
    expect(find.text('A little strength for my mom'), findsNothing);
    await tester.tap(find.text('I prayed'));
    await tester.pumpAndSettle();
    expect(find.text('19 prayers'), findsOneWidget);
    await tester.tap(find.text('Prayed'));
    await tester.pumpAndSettle();
    expect(find.text('18 prayers'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    debugDefaultTargetPlatformOverride = null;
  });
  testWidgets(
      'Narrow dark phone lays out every tab and the reflection composer',
      (tester) async {
    SharedPreferences.setMockInitialValues({'theme': 'dark'});
    await launch(tester, const Size(320, 800));
    expect(tester.takeException(), isNull);
    for (final label in ['Community', 'Prayers', 'Profile']) {
      await tester.tap(find.byTooltip(label).last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: label);
    }
    await tester.tap(find.widgetWithText(ChoiceChip, 'Journal'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Write a reflection'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byType(TextField), 'Thankful for a quiet morning.');
    await tester.tap(find.text('Save reflection'));
    await tester.pumpAndSettle();
    expect(find.text('Thankful for a quiet morning.'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    debugDefaultTargetPlatformOverride = null;
  });
  testWidgets('Large text and reduced motion preserve controls',
      (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    tester.platformDispatcher.textScaleFactorTestValue = 1.8;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await launch(tester, const Size(390, 1100), scale: 1.8);
    expect(
        MediaQuery.textScalerOf(tester.element(find.text('Prayer Wall').first))
            .scale(1),
        1.8);
    for (final label in ['Wall', 'Community', 'Prayers', 'Profile']) {
      await tester.tap(find.byTooltip(label).last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: label);
    }
    await tester.pumpWidget(const SizedBox());
    debugDefaultTargetPlatformOverride = null;
  });
  test('Profile data persists without changing prayers', () async {
    SharedPreferences.setMockInitialValues({});
    final store = PrayerStore();
    await store.load();
    await store.changePrayer('add',
        item: const PrayerItem('keep', 'A private prayer'));
    expect(await store.saveProfile('  Alex  ', 'Here to pray.', null), true);
    final restored = PrayerStore();
    await restored.load();
    expect(restored.profileName, 'Alex');
    expect(restored.profileBio, 'Here to pray.');
    expect(restored.profilePhoto, isNull);
    expect(restored.prayers.single.id, 'keep');
    expect(await restored.saveProfile('x' * 61, '', null), false);
    expect(restored.profileName, 'Alex');
    store.dispose();
    restored.dispose();
  });
  testWidgets('Category art is singular and profile owns settings',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await launch(tester, const Size(390, 844));
    expect(find.text('Prayer categories'), findsOneWidget);
    expect(
        find.descendant(
            of: find.byKey(const ValueKey('category-Hope')),
            matching: find.byType(Art)),
        findsOneWidget);
    expect(find.byTooltip('Settings'), findsNothing);
    await tester.tap(find.bySemanticsLabel('Open profile'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Settings'), findsOneWidget);
    expect(find.text('Your name'), findsOneWidget);
    await tester.tap(find.text('Edit profile'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Your name'), 'Alex');
    await tester.enterText(
        find.widgetWithText(TextField, 'About you (optional)'),
        'Here to pray.');
    await tester.tap(find.text('Save profile'));
    await tester.pumpAndSettle();
    expect(find.text('Alex'), findsOneWidget);
    expect(find.text('Here to pray.'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    debugDefaultTargetPlatformOverride = null;
  });
  testWidgets('Inset dock notch and create button share a center on Android',
      (tester) async {
    for (final width in [320.0, 390.0, 430.0]) {
      for (final bottom in [0.0, 24.0, 48.0]) {
        tester.view.padding = FakeViewPadding(bottom: bottom);
        tester.view.viewPadding = FakeViewPadding(bottom: bottom);
        await launch(tester, Size(width, 900));
        final dock = tester.getRect(find.byKey(const ValueKey('prayer-dock')));
        final button =
            tester.getRect(find.byKey(const ValueKey('dock-create')));
        expect(button.center.dx, closeTo(dock.center.dx, .01));
        expect(button.center.dy, closeTo(dock.top, .01));
        final path = const DockClipper().getClip(dock.size);
        // The circular cutout must be symmetric around the actual button,
        // even though the dock itself has a horizontal outer inset.
        for (final x in [12.0, 24.0, 32.0, 40.0]) {
          expect(path.contains(Offset(dock.width / 2 - x, 16)),
              path.contains(Offset(dock.width / 2 + x, 16)));
        }
        expect(path.contains(Offset(dock.width / 2, 16)), false);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      }
    }
    tester.view.resetPadding();
    tester.view.resetViewPadding();
    debugDefaultTargetPlatformOverride = null;
  });
}
