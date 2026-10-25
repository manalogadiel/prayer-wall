import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prayer_wall/app/app.dart';
import 'package:prayer_wall/core/store.dart';
import 'package:prayer_wall/features/wall/post_composer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final f in [('Outfit', 'Outfit'), ('DM Sans', 'DMSans')]) {
      await (FontLoader(f.$1)
            ..addFont(rootBundle.load('assets/fonts/${f.$2}.ttf')))
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
      'All five post materials survive save, edit and reload with sticker placement',
      () async {
    final store = PrayerStore();
    await store.load();
    for (final d in PostDesign.values) {
      expect(
          await store.savePost(WallPost('You', 'Y', 'Hope',
              'Prayer on ${d.name}', 'A hope for our family.', 0,
              id: d.name,
              local: true,
              design: d,
              sticker: StickerKind.lamp,
              backgroundSticker: true,
              createdAt: DateTime(2026, 10, 25))),
          true);
    }
    final first = store.localPosts.first;
    expect(
        await store.savePost(first.edit(
            title: 'Edited prayer',
            body: first.body,
            topic: first.topic,
            design: first.design,
            sticker: StickerKind.ark,
            backgroundSticker: false)),
        true);
    final restored = PrayerStore();
    await restored.load();
    expect(restored.localPosts.length, 5);
    expect(restored.localPosts.map((p) => p.design).toSet(),
        PostDesign.values.toSet());
    expect(restored.localPosts.first.id, first.id);
    expect(restored.localPosts.first.title, 'Edited prayer');
    expect(restored.localPosts.first.sticker, StickerKind.ark);
    expect(restored.localPosts.first.backgroundSticker, false);
    expect(restored.localPosts.first.createdAt, DateTime(2026, 10, 25));
    await restored.deletePost(first.id);
    await restored.load();
    expect(restored.localPosts.length, 4);
    store.dispose();
    restored.dispose();
  });
  test(
      'Prayed and saved states persist independently and serialize repeat taps',
      () async {
    final store = PrayerStore();
    await store.load();
    final post = store.posts.first;
    await Future.wait(
        [store.pray(post), store.changePostState(post, save: true)]);
    expect(post.prayed, true);
    expect(post.saved, true);
    expect(post.count, post.baseCount + 1);
    final restored = PrayerStore();
    await restored.load();
    final p = restored.posts.first;
    expect(p.prayed, true);
    expect(p.saved, true);
    await restored.pray(p);
    expect(p.prayed, false);
    expect(p.saved, true);
    expect(p.count, p.baseCount);
    await restored.load();
    expect(restored.posts.first.count, p.baseCount);
    expect(
        await restored
            .savePost(WallPost('You', 'Y', 'Hope', ' ', '', 0, local: true)),
        false);
    expect(await restored.savePost(store.posts.first), false);
    store.dispose();
    restored.dispose();
  });
  testWidgets('Create a customized local post through the live composer',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: PrayerWallApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Create post'));
    await tester.pumpAndSettle();
    final title = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Post title');
    final body = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Your prayer');
    await tester.enterText(title, 'A new beginning');
    await tester.enterText(body, 'Praying for courage for the next step.');
    final paper = find.widgetWithText(ChoiceChip, 'Paper');
    await tester.ensureVisible(paper);
    await tester.tap(paper);
    await tester.pumpAndSettle();
    final background = find.widgetWithText(ChoiceChip, 'Background');
    await tester.ensureVisible(background);
    await tester.tap(background);
    await tester.pumpAndSettle();
    final store =
        ProviderScope.containerOf(tester.element(find.byType(PostComposer)))
            .read(storeProvider);
    await tester.tap(find.text('Save to my wall'));
    await tester.pumpAndSettle();
    expect(store.localPosts.single.title, 'A new beginning');
    expect(store.localPosts.single.design, PostDesign.paper);
    expect(store.localPosts.single.backgroundSticker, true);
    expect(find.text('Only on this device'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    debugDefaultTargetPlatformOverride = null;
  });
  testWidgets('Community selector searches and stores a local space',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: PrayerWallApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Community').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Peace');
    await tester.pumpAndSettle();
    expect(find.text('Everyday gratitude'), findsNothing);
    await tester.tap(find.text('Peace in the waiting'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Add to my spaces'));
    await tester.tap(find.text('Add to my spaces'));
    await tester.pumpAndSettle();
    expect(find.text('Leave my spaces'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    debugDefaultTargetPlatformOverride = null;
  });
}
