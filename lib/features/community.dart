import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app/theme.dart';
import '../core/store.dart';
import '../core/widgets.dart';
import 'wall/post_design.dart';

const spaces = [
  (
    'Family',
    'Family',
    'Pray with the people closest to you.',
    StickerKind.lamb,
    'mint'
  ),
  (
    'Young People',
    'Hope',
    'Growing in faith, together.',
    StickerKind.ark,
    'peach'
  ),
  (
    'School Friends',
    'Peace',
    'A space for your school community.',
    StickerKind.boat,
    'blue'
  ),
];

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({required this.onWall, super.key});
  final ValueChanged<String> onWall;
  @override
  ConsumerState<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends ConsumerState<CommunityPage> {
  String search = '';
  bool mine = false;
  void detail((String, String, String, StickerKind, String) e) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (c) => Consumer(builder: (c, ref, _) {
              final joined = ref.watch(storeProvider).joined.contains(e.$1);
              return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                            child: Container(
                                width: 160,
                                height: 190,
                                decoration: BoxDecoration(
                                    color: tint(c, e.$5),
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(90),
                                        bottom: Radius.circular(28))),
                                child: Art(stickerAsset(e.$4)!, size: 150))),
                        const SizedBox(height: 24),
                        Text(e.$1, style: Theme.of(c).textTheme.headlineMedium),
                        const SizedBox(height: 12),
                        Text(e.$3),
                        const SizedBox(height: 12),
                        const SizedBox(height: 24),
                        ActionButton(
                            joined ? 'Leave my spaces' : 'Add to my spaces',
                            icon: joined
                                ? CupertinoIcons.check_mark
                                : CupertinoIcons.plus,
                            onTap: () => ref.read(storeProvider).join(e.$1)),
                        const SizedBox(height: 10),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(c);
                              widget.onWall(e.$2);
                            },
                            child: const Text('View prayers')),
                      ]));
            }));
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(storeProvider);
    final s = Theme.of(context).colorScheme;

    final results = spaces
        .where((e) =>
            (!mine || store.joined.contains(e.$1)) &&
            (e.$1.toLowerCase().contains(search.toLowerCase()) ||
                e.$2.toLowerCase().contains(search.toLowerCase())))
        .toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('Find a little\nbelonging.',
          style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 10),
      const Text('Different seasons. A place to pray together.'),
      const SizedBox(height: 20),
      TextField(
          onChanged: (v) => setState(() => search = v),
          decoration: const InputDecoration(
              labelText: 'Search spaces',
              prefixIcon: Icon(CupertinoIcons.search))),
      const SizedBox(height: 16),
      BibleTabs(
          labels: const ['Discover', 'My spaces'],
          index: mine ? 1 : 0,
          onChanged: (i) => setState(() => mine = i == 1)),
      const SizedBox(height: 18),
      if (results.isEmpty)
        EmptyView(
            title: mine ? 'Your spaces start here' : 'No spaces found',
            body: mine
                ? 'Choose Discover and add a space that speaks to your season.'
                : 'Try another name or prayer topic.',
            action: mine
                ? ActionButton('Discover spaces',
                    onTap: () => setState(() => mine = false))
                : null),
      LayoutBuilder(builder: (c, box) {
        final wide = box.maxWidth >= 700;
        Widget card((String, String, String, StickerKind, String) e) {
          final joined = store.joined.contains(e.$1);
          return Pressable(
              onTap: () => detail(e),
              color: tint(context, e.$5),
              radius: 24,
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(builder: (c, b) {
                final artWidth = b.maxWidth > 300 ? 140.0 : 104.0;
                final large = MediaQuery.textScalerOf(c).scale(1) > 1.4;
                return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                            Text(e.$1, style: Theme.of(c).textTheme.titleLarge),
                            const SizedBox(height: 10),
                            Text(e.$3,
                                style: TextStyle(
                                    fontSize: 12,
                                    height: 1.45,
                                    color: s.onSurface)),
                            const SizedBox(height: 18),
                            Row(children: [
                              Icon(
                                  joined
                                      ? CupertinoIcons.check_mark_circled_solid
                                      : CupertinoIcons.arrow_up_right,
                                  size: 18,
                                  color: s.onSurface),
                              const SizedBox(width: 6),
                              Flexible(
                                  child: Text(
                                      joined ? 'In my spaces' : 'Explore space',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: s.onSurface)))
                            ]),
                          ])),
                      if (!large) ...[
                        const SizedBox(width: 14),
                        ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(artWidth),
                                bottom: const Radius.circular(28)),
                            child: Container(
                                width: artWidth,
                                height: artWidth * 1.22,
                                color: s.surface.withValues(alpha: .48),
                                child: Transform.scale(
                                    scale: 1.12,
                                    child: Art(stickerAsset(e.$4)!,
                                        size: artWidth))))
                      ],
                    ]);
              }));
        }

        return Wrap(spacing: 16, runSpacing: 16, children: [
          for (final e in results)
            SizedBox(
                width: wide ? (box.maxWidth - 16) / 2 : box.maxWidth,
                child: card(e))
        ]);
      }),
    ]);
  }
}
