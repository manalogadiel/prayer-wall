import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'profile_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app/theme.dart';
import '../core/store.dart';
import '../core/widgets.dart';
import 'entry_dialog.dart';
import 'personal_widgets.dart';
import 'community.dart';
import 'wall/wall_feed.dart';
import 'wall/post_composer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  int page = 0;
  bool answered = false;
  int prayerTab = 0;
  String filter = 'Everyone';
  Timer? dayTimer;
  static const labels = ['Wall', 'Community', 'Prayers', 'Profile'];
  int profileTab = 0;
  bool wallSearching = false;
  static const icons = [
    CupertinoIcons.square_grid_2x2,
    CupertinoIcons.person_2,
    CupertinoIcons.heart,
    CupertinoIcons.person_crop_circle
  ];
  static const selectedIcons = [
    CupertinoIcons.square_grid_2x2_fill,
    CupertinoIcons.person_2_fill,
    CupertinoIcons.heart_fill,
    CupertinoIcons.person_crop_circle_fill
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (isAndroid) recoverPhoto();
    dayTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> recoverPhoto() async {
    try {
      final result = await ImagePicker().retrieveLostData();
      if (result.files?.isNotEmpty != true) return;
      final bytes = await result.files!.first.readAsBytes();
      if (bytes.length > 1024 * 1024) return;
      final store = ref.read(storeProvider);
      await store.load();
      if (mounted && !store.loadFailed) {
        await editProfile(context, store, recoveredPhoto: base64Encode(bytes));
      }
    } catch (_) {/* The saved avatar remains available if recovery fails. */}
  }

  @override
  void dispose() {
    dayTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) ref.read(storeProvider).load();
  }

  void go(int i) => setState(() => page = i);
  void message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  Future<void> compose(
      {PrayerItem? prayer, JournalEntry? entry, bool journal = false}) async {
    final store = ref.read(storeProvider);
    await showDialog<bool>(
        context: context,
        builder: (_) => EntryDialog(
            journal: journal,
            editing: prayer != null || entry != null,
            initial: journal ? entry?.body ?? '' : prayer?.title ?? '',
            onSave: (text) => journal
                ? store.saveJournal(text, entry: entry)
                : store.changePrayer(prayer == null ? 'add' : 'edit',
                    id: prayer?.id,
                    item: prayer?.copy(title: text) ??
                        PrayerItem(
                            DateTime.now().microsecondsSinceEpoch.toString(),
                            text))));
  }

  Future<void> startPrayer() async {
    final prayers =
        ref.read(storeProvider).prayers.where((p) => !p.answered && !p.done);
    if (prayers.isEmpty) {
      if (ref.read(storeProvider).prayers.where((p) => !p.answered).isEmpty) {
        openPostComposer(context);
      } else {
        message(
            'You’ve prayed through your list today. There’s room to return anytime.');
      }
      return;
    }
    await showDialog<void>(
        context: context, builder: (_) => FocusPrayerDialog(prayers.first));
  }

  Future<void> pinWidget() async {
    if (!isAndroid) {
      message(
          'On Android, use Add to home screen or find Prayer Wall in your home-screen widget picker. This is an interactive preview.');
      return;
    }
    try {
      final ok = await widgetChannel.invokeMethod<bool>('pinWidget') ?? false;
      if (!mounted) return;
      message(ok
          ? 'Finish adding the widget in your launcher.'
          : 'Long-press your home screen, choose Widgets, then Prayer Wall.');
    } catch (_) {
      if (mounted) {
        message(
            'Long-press your home screen, choose Widgets, then Prayer Wall.');
      }
    }
  }

  void settings() => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (c) => Consumer(builder: (c, ref, _) {
            final store = ref.watch(storeProvider);
            return SafeArea(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Make yourself at home',
                              style: Theme.of(c).textTheme.headlineSmall),
                          const SizedBox(height: 24),
                          Text('Appearance',
                              style: Theme.of(c).textTheme.titleMedium),
                          const SizedBox(height: 12),
                          Wrap(spacing: 8, runSpacing: 8, children: [
                            for (final mode in ThemeMode.values)
                              ChoiceChip(
                                  label: Text(switch (mode) {
                                    ThemeMode.system => 'System',
                                    ThemeMode.light => 'Light',
                                    ThemeMode.dark => 'Dark'
                                  }),
                                  selected: store.mode == mode,
                                  labelStyle: TextStyle(
                                      color: store.mode == mode
                                          ? Theme.of(c).colorScheme.onPrimary
                                          : Theme.of(c).colorScheme.onSurface),
                                  onSelected: (_) => store.setTheme(mode))
                          ]),
                          const SizedBox(height: 24),
                          Text('Your private space',
                              style: Theme.of(c).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          const Text(
                              'Public visibility is saved locally in this preview. Online publishing, prayer partners and fellowship require a connected account service. Your prayers and photos stay on this device.'),
                          const SizedBox(height: 16),
                          ActionButton('Copy my data',
                              secondary: true,
                              icon: CupertinoIcons.doc_on_doc,
                              onTap: store.loadFailed
                                  ? null
                                  : () async {
                                      await Clipboard.setData(ClipboardData(
                                          text: store.exportData()));
                                      if (c.mounted) {
                                        Navigator.pop(c);
                                        message(
                                            'Your local data is copied. Paste it into a private file to keep a backup.');
                                      }
                                    }),
                          const SizedBox(height: 8),
                          const Text(
                              'Copies your prayers, journal, and local posts as JSON to your clipboard. Native widgets follow Android’s system appearance.'),
                        ])));
          }));
  @override
  Widget build(BuildContext context) {
    final store = ref.watch(storeProvider);
    final wide = MediaQuery.sizeOf(context).width >= 1000;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: wide
          ? null
          : Padding(
              padding: EdgeInsets.fromLTRB(
                  16, 0, 16, 12 + MediaQuery.paddingOf(context).bottom),
              child: SizedBox(
                  height: 92,
                  child: Stack(clipBehavior: Clip.none, children: [
                    Positioned(
                        left: 0,
                        right: 0,
                        top: 28,
                        height: 64,
                        child: ClipPath(
                            key: const ValueKey('prayer-dock'),
                            clipper: const DockClipper(),
                            child: Material(
                                color: const Color(0xFF0D0E12),
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: navigation(false))))),
                    Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                            width: 56,
                            height: 56,
                            child: FloatingActionButton(
                                key: const ValueKey('dock-create'),
                                tooltip: 'Create post',
                                onPressed: () => openPostComposer(context),
                                backgroundColor: const Color(0xFFF9F9F3),
                                foregroundColor: const Color(0xFF17181C),
                                shape: const CircleBorder(),
                                elevation: 2,
                                child: const Icon(CupertinoIcons.plus,
                                    size: 28)))),
                  ]))),
      body: SafeArea(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (wide)
          Container(
              width: 220,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              color: scheme.surface,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(children: [
                      const Art(doveAsset, size: 38),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text('Prayer Wall',
                              style: Theme.of(context).textTheme.titleLarge))
                    ]),
                    const SizedBox(height: 40),
                    navigation(true),
                    const SizedBox(height: 24),
                    ActionButton('Create post',
                        icon: CupertinoIcons.plus,
                        onTap: () => openPostComposer(context)),
                    const Spacer(),
                    const Art('assets/illustrations/objects/lamp_v001.png',
                        size: 90),
                    const SizedBox(height: 12),
                    const Text(
                        'A place for your words.\nA little hope for the day.',
                        textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                  ])),
        Expanded(
            child: Column(children: [
          Padding(
              padding:
                  EdgeInsets.fromLTRB(wide ? 32 : 20, 14, wide ? 32 : 12, 12),
              child: Row(children: [
                if (page == 0) ...[
                  Pressable(
                      onTap: () => go(3),
                      radius: 24,
                      color: tint(context, 'lilac'),
                      padding: const EdgeInsets.all(4),
                      label: 'Open profile',
                      child:
                          ProfileAvatar(photo: store.profilePhoto, size: 40)),
                  const SizedBox(width: 12)
                ],
                Expanded(
                    child: Text(page == 0 ? 'Prayer Wall' : labels[page],
                        style: Theme.of(context).textTheme.headlineSmall)),
                if (page == 0)
                  IconButton(
                      tooltip: 'Search wall',
                      onPressed: () =>
                          setState(() => wallSearching = !wallSearching),
                      icon: const Icon(CupertinoIcons.search, size: 22)),
                if (page == 3)
                  IconButton(
                      tooltip: 'Settings',
                      onPressed: settings,
                      icon: const Icon(CupertinoIcons.slider_horizontal_3,
                          size: 22)),
              ])),
          Expanded(
              child: !store.ready
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      key: ValueKey(page),
                      padding: EdgeInsets.fromLTRB(
                          wide ? 32 : 20, 8, wide ? 32 : 20, 24),
                      child: Center(
                          child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: page == 0
                                      ? 680
                                      : page == 1
                                          ? 940
                                          : 1000),
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    if (store.error != null)
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          child: Surface(
                                              color: tint(context, 'peach'),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Semantics(
                                                        liveRegion: true,
                                                        child:
                                                            Text(store.error!)),
                                                    if (store.loadFailed)
                                                      TextButton(
                                                          onPressed: store.load,
                                                          child: const Text(
                                                              'Try again'))
                                                  ]))),
                                    if (!store.loadFailed)
                                      switch (page) {
                                        0 => WallFeed(
                                            topic: filter,
                                            showSearch: wallSearching),
                                        1 => CommunityPage(onWall: (topic) {
                                            setState(() {
                                              filter = topic;
                                              page = 0;
                                            });
                                          }),
                                        2 => personal(store),
                                        _ => profile(store),
                                      },
                                  ]))))),
        ])),
      ])),
    );
  }

  Widget profile(PrayerStore store) =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Surface(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            ProfileAvatar(photo: store.profilePhoto, size: 80),
            const SizedBox(width: 16),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                      store.profileName.isEmpty
                          ? 'Your name'
                          : store.profileName,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 6),
                  if (store.profileBio.isNotEmpty) Text(store.profileBio),
                ]))
          ]),
          const SizedBox(height: 16),
          Wrap(spacing: 12, children: [
            TextButton(
                onPressed: () => connectionSheet('Prayer partners'),
                child: const Text('Prayer partners')),
            TextButton(
                onPressed: () => connectionSheet('Fellowship'),
                child: const Text('Fellowship'))
          ]),
          const SizedBox(height: 18),
          ActionButton('Edit profile',
              icon: CupertinoIcons.pencil,
              onTap: () => editProfile(context, store)),
        ])),
        const SizedBox(height: 20),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (var i = 0; i < 3; i++)
            filterChip(['Today', 'Journal', 'Saved'][i], profileTab == i,
                () => setState(() => profileTab = i))
        ]),
        const SizedBox(height: 24),
        if (profileTab == 0) ...[
          Text(greeting(), style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          today(store)
        ] else if (profileTab == 1)
          journal(store)
        else
          const WallFeed(savedOnly: true),
      ]);

  void connectionSheet(String title) => showModalBottomSheet<void>(
      context: context,
      builder: (c) => SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Art(doveAsset, size: 90),
                Text(title, style: Theme.of(c).textTheme.headlineSmall),
                const SizedBox(height: 12),
                const Text('No connections yet.'),
                const SizedBox(height: 12),
                TextButton(
                    onPressed: () => Navigator.pop(c),
                    child: const Text('Close'))
              ]))));

  String greeting() {
    final n = DateTime.now();
    final greeting = n.hour < 12
        ? 'Good morning'
        : n.hour < 18
            ? 'Good afternoon'
            : 'Good evening';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '$greeting · ${months[n.month - 1]} ${n.day}';
  }

  Widget navigation(bool vertical) {
    final s = Theme.of(context).colorScheme;
    Widget destination(int i) => Tooltip(
        excludeFromSemantics: !vertical,
        message: labels[i],
        child: Pressable(
            onTap: () => go(i),
            selected: page == i,
            label: vertical ? null : labels[i],
            radius: 20,
            color: vertical && page == i
                ? s.onSurface.withValues(alpha: .08)
                : Colors.transparent,
            padding: EdgeInsets.symmetric(
                horizontal: vertical ? 14 : 4, vertical: 10),
            child: vertical
                ? Row(children: [
                    AnimatedGlyph(
                        active: page == i,
                        icon: icons[i],
                        selectedIcon: selectedIcons[i],
                        color: s.onSurface,
                        size: 23),
                    const SizedBox(width: 12),
                    Text(labels[i],
                        style: const TextStyle(fontWeight: FontWeight.w600))
                  ])
                : SizedBox(
                    height: 40,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedGlyph(
                              active: page == i,
                              icon: icons[i],
                              selectedIcon: selectedIcons[i],
                              color: page == i
                                  ? Colors.white
                                  : const Color(0xFFAAABB3),
                              size: 23),
                          const SizedBox(height: 5),
                          Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: page == i
                                      ? Colors.white
                                      : Colors.transparent)),
                        ]))));
    if (vertical) {
      return Column(children: [
        for (var i = 0; i < 4; i++)
          Padding(
              padding: const EdgeInsets.only(bottom: 10), child: destination(i))
      ]);
    }
    return Row(children: [
      Expanded(child: destination(0)),
      Expanded(child: destination(1)),
      const SizedBox(width: 72),
      Expanded(child: destination(2)),
      Expanded(child: destination(3))
    ]);
  }

  Widget today(PrayerStore store) {
    final active = store.prayers
        .where(
            (p) => !p.answered && (store.postForPrayer(p.id)?.visible ?? true))
        .toList();
    final primary =
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Align(
              alignment: Alignment.centerLeft,
              child: ActionButton('Start praying',
                  icon: CupertinoIcons.arrow_right, onTap: startPrayer))),
      SectionTitle('Your prayers today',
          action: 'Add prayer', onTap: () => openPostComposer(context)),
      if (active.isEmpty)
        Surface(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Start with one small prayer.',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
              'Keep a person, a hope, or a thank-you close throughout your day.'),
        ]))
      else
        Surface(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final p in active.take(4))
                    PrayerRow(p, onEdit: () {
                      final post = store.postForPrayer(p.id);
                      if (post != null) {
                        openPostComposer(context, post: post);
                      } else {
                        compose(prayer: p);
                      }
                    }),
                  Padding(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: Text(
                          '${active.where((p) => p.done).length} of ${active.length} prayed today',
                          style: Theme.of(context).textTheme.bodySmall)),
                  if (active.length > 4)
                    TextButton(
                        onPressed: () => go(2),
                        child: const Text('See all prayers')),
                ])),
    ]);
    final secondary =
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Surface(
          color: tint(context, 'blue'),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(
                  child: Text('Peace in\nthe waiting',
                      style: Theme.of(context).textTheme.titleLarge)),
              const Art(boatAsset, size: 96)
            ]),
            const SizedBox(height: 8),
            const Text(
                'Take a quiet moment with the story of Jesus calming the storm.'),
            const SizedBox(height: 6),
            TextButton(
                onPressed: reflection, child: const Text('Read & reflect')),
          ])),
      const SizedBox(height: 16),
      Surface(
          color: tint(context, 'butter'),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                  child: Text('Room for gratitude',
                      style: Theme.of(context).textTheme.titleLarge)),
              const Art('assets/illustrations/objects/loaves_fish_v001.png',
                  size: 72)
            ]),
            const SizedBox(height: 8),
            const Text('What is one small thing you’re thankful for today?'),
            const SizedBox(height: 8),
            TextButton(
                onPressed: () => compose(journal: true),
                child: const Text('Write a reflection')),
          ])),
    ]);
    return LayoutBuilder(
        builder: (_, box) => box.maxWidth >= 720
            ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(flex: 3, child: primary),
                const SizedBox(width: 24),
                Expanded(flex: 2, child: secondary)
              ])
            : Column(
                children: [primary, const SizedBox(height: 24), secondary]));
  }

  void reflection() => showDialog<void>(
      context: context,
      builder: (c) => Dialog(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(child: Art(boatAsset, size: 140)),
                        const SizedBox(height: 16),
                        Text('Peace in the waiting',
                            style: Theme.of(c).textTheme.headlineSmall),
                        const SizedBox(height: 12),
                        const SmallTag('Mark 4:35–41', role: 'blue'),
                        const SizedBox(height: 16),
                        const Text(
                            'In this story, Jesus and his disciples cross the lake. A storm rises, the disciples are afraid, and Jesus calms the wind and sea. This is a brief story summary, not a Bible quotation.'),
                        const SizedBox(height: 16),
                        const Text(
                            'What are you carrying today? What would you like to bring into prayer?'),
                        const SizedBox(height: 24),
                        ActionButton('Write a reflection', onTap: () {
                          Navigator.pop(c);
                          compose(journal: true);
                        }),
                        TextButton(
                            onPressed: () => Navigator.pop(c),
                            child: const Text('Close')),
                      ])))));
  Widget personal(PrayerStore store) {
    final items = store.prayers.where((p) {
      final post = store.postForPrayer(p.id);
      final hidden = post != null && !post.visible;
      return prayerTab == 2
          ? hidden
          : !hidden && p.answered == (prayerTab == 1);
    }).toList();
    final list =
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      BibleTabs(
          labels: const ['Active', 'Answered', 'Archive'],
          index: prayerTab,
          onChanged: (i) => setState(() {
                prayerTab = i;
                answered = i == 1;
              })),
      const SizedBox(height: 12),
      if (prayerTab == 0)
        Align(
            alignment: Alignment.centerLeft,
            child: ActionButton('Add prayer',
                icon: CupertinoIcons.plus,
                onTap: () => openPostComposer(context))),
      const SizedBox(height: 20),
      if (items.isEmpty)
        EmptyView(
            title: answered ? 'Remember the good.' : 'Make room for a prayer',
            body: answered
                ? 'Prayers you mark answered will be kept here. Checking “Prayed today” won’t move them.'
                : 'A simple list for the people and hopes you want to keep close.',
            action: null)
      else
        Surface(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              for (final p in items)
                PrayerRow(p, onEdit: () {
                  final post = store.postForPrayer(p.id);
                  if (post != null) {
                    openPostComposer(context, post: post);
                  } else {
                    compose(prayer: p);
                  }
                })
            ])),
    ]);
    final widget =
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SectionTitle('A little closer'),
      const Text('Keep your prayers close, wherever the day takes you.'),
      const SizedBox(height: 16),
      const WidgetPreview(),
      const SizedBox(height: 16),
      ActionButton('Add to home screen',
          icon: CupertinoIcons.square_grid_2x2, onTap: pinWidget),
      const SizedBox(height: 12),
      const Text(
          'Interactive Android widget · Up to 3 prayers\nPrayer titles are visible on your home screen. Use a prayer’s menu to include or remove it.',
          style: TextStyle(fontSize: 12, height: 1.5)),
    ]);
    return LayoutBuilder(
        builder: (_, box) => box.maxWidth >= 720
            ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(flex: 3, child: list),
                const SizedBox(width: 32),
                Expanded(flex: 2, child: widget)
              ])
            : Column(children: [list, const SizedBox(height: 32), widget]));
  }

  Widget filterChip(String label, bool selected, VoidCallback tap) =>
      ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => tap(),
          labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface));
  Widget journal(PrayerStore store) =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 16,
            runSpacing: 16,
            children: [
              const Text(
                  'Your thoughts. A little quieter.\nPrivate, on this device.'),
              ActionButton('Write a reflection',
                  icon: CupertinoIcons.plus,
                  onTap: () => compose(journal: true))
            ]),
        const SizedBox(height: 24),
        if (store.journal.isEmpty)
          EmptyView(
              asset: journalAsset,
              title: 'A page for what matters',
              body:
                  'Keep a prayer, a small thank-you, or a thought you want to return to.',
              action: ActionButton('Start writing',
                  onTap: () => compose(journal: true)))
        else ...[
          for (final e in store.journal)
            Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Surface(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(children: [
                        Expanded(
                            child: Text(
                                e.createdAt == null
                                    ? 'Earlier reflection'
                                    : '${e.createdAt!.day}/${e.createdAt!.month}/${e.createdAt!.year}',
                                style: Theme.of(context).textTheme.bodySmall)),
                        PopupMenuButton<String>(
                            tooltip: 'Reflection options',
                            onSelected: (v) {
                              if (v == 'edit') {
                                compose(journal: true, entry: e);
                              } else {
                                deleteReflection(e);
                              }
                            },
                            itemBuilder: (_) => const [
                                  PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Edit reflection')),
                                  PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete reflection'))
                                ])
                      ]),
                      const SizedBox(height: 8),
                      SelectableText(e.body,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ])))
        ],
      ]);
  Future<void> deleteReflection(JournalEntry e) async {
    final yes = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
                title: const Text('Delete this reflection?'),
                content: const Text('This removes it from this device.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(c, false),
                      child: const Text('Keep reflection')),
                  TextButton(
                      onPressed: () => Navigator.pop(c, true),
                      child: const Text('Delete'))
                ]));
    if (yes == true) await ref.read(storeProvider).deleteJournal(e.id);
  }
}

class DockShape extends NotchedShape {
  const DockShape();
  @override
  Path getOuterPath(Rect host, Rect? guest) {
    final rounded = Path()
      ..addRRect(RRect.fromRectAndRadius(host, const Radius.circular(34)));
    return Path.combine(PathOperation.intersect, rounded,
        const CircularNotchedRectangle().getOuterPath(host, guest));
  }
}

// Local coordinates keep the notch aligned when the whole dock is inset.
class DockClipper extends CustomClipper<Path> {
  const DockClipper();
  @override
  Path getClip(Size size) => const DockShape().getOuterPath(
      Offset.zero & size,
      Rect.fromCenter(
          center: Offset(size.width / 2, 0), width: 68, height: 68));
  @override
  bool shouldReclip(DockClipper oldClipper) => false;
}
