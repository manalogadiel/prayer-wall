import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../core/store.dart';
import '../../core/widgets.dart';
import 'post_composer.dart';
import '../profile_editor.dart';
import 'post_design.dart';

class WallFeed extends ConsumerStatefulWidget {
  const WallFeed(
      {this.topic = 'Everyone',
      this.savedOnly = false,
      this.showSearch = false,
      super.key});
  final String topic;
  final bool savedOnly, showSearch;
  @override
  ConsumerState<WallFeed> createState() => _WallFeedState();
}

class _WallFeedState extends ConsumerState<WallFeed> {
  late String filter = widget.topic;
  String search = '';
  @override
  void didUpdateWidget(WallFeed old) {
    super.didUpdateWidget(old);
    if (old.topic != widget.topic) filter = widget.topic;
    if (old.showSearch && !widget.showSearch) search = '';
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(storeProvider);
    final s = Theme.of(context).colorScheme;
    final items = (widget.savedOnly
            ? store.feed.where((p) => p.visible)
            : store.publicFeed)
        .where((p) =>
            (filter == 'Everyone' || p.topic == filter) &&
            (!widget.savedOnly || p.saved) &&
            ('${p.title} ${p.body}'
                .toLowerCase()
                .contains(search.toLowerCase())))
        .toList();
    const stories = [
      ('Hope', StickerKind.dove, 'lilac'),
      ('Peace', StickerKind.boat, 'blue'),
      ('Family', StickerKind.lamb, 'mint'),
      ('Gratitude', StickerKind.bread, 'butter')
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (widget.showSearch) ...[
        TextField(
            onChanged: (v) => setState(() => search = v),
            decoration: const InputDecoration(
                labelText: 'Search prayers',
                prefixIcon: Icon(CupertinoIcons.search))),
        const SizedBox(height: 16)
      ],
      if (!widget.savedOnly) ...[
        const SectionTitle('Prayer categories'),
        LayoutBuilder(
            builder: (context, box) => SizedBox(
                height:
                    MediaQuery.textScalerOf(context).scale(1) > 1.4 ? 178 : 144,
                child: OverflowBox(
                    minWidth: box.maxWidth + 40,
                    maxWidth: box.maxWidth + 40,
                    child: SizedBox(
                        height: MediaQuery.textScalerOf(context).scale(1) > 1.4
                            ? 178
                            : 144,
                        child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            scrollDirection: Axis.horizontal,
                            itemCount: stories.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (_, i) {
                              final e = stories[i];
                              final topic = e.$1;
                              return SizedBox(
                                  width: 92,
                                  key: ValueKey('category-${e.$1}'),
                                  child: Pressable(
                                      onTap: () =>
                                          setState(() => filter = topic),
                                      radius: 24,
                                      child: Column(children: [
                                        Container(
                                            height: 100,
                                            width: 92,
                                            decoration: BoxDecoration(
                                                color: tint(context, e.$3),
                                                borderRadius:
                                                    BorderRadius.circular(26)),
                                            child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Transform.rotate(
                                                      angle:
                                                          i.isEven ? -.08 : .08,
                                                      child: Art(
                                                          stickerAsset(e.$2)!,
                                                          size: 82)),
                                                  if (filter == topic)
                                                    Positioned(
                                                        top: 6,
                                                        right: 6,
                                                        child: Icon(
                                                            CupertinoIcons
                                                                .check_mark_circled_solid,
                                                            size: 18,
                                                            color: s.primary)),
                                                ])),
                                        const SizedBox(height: 8),
                                        Text(e.$1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: s.onSurface)),
                                      ])));
                            }))))),
        const SizedBox(height: 8),
        Pressable(
            onTap: () => openPostComposer(context),
            color: s.surface,
            radius: 22,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(children: [
              ProfileAvatar(photo: store.profilePhoto, size: 38),
              const SizedBox(width: 12),
              Expanded(
                  child: Text('What’s on your heart?',
                      style:
                          TextStyle(color: s.onSurfaceVariant, fontSize: 14))),
              Icon(CupertinoIcons.pencil, size: 23, color: s.primary),
            ])),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(
              child: Text(filter == 'Everyone' ? 'Praying, together.' : filter,
                  style: Theme.of(context).textTheme.titleLarge)),
          if (filter != 'Everyone')
            TextButton(
                onPressed: () => setState(() => filter = 'Everyone'),
                child: const Text('Everyone'))
        ]),
        const SizedBox(height: 6),
        const SizedBox(height: 20),
      ],
      if (items.isEmpty)
        EmptyView(
            title:
                widget.savedOnly ? 'A place to return to' : 'Room for a prayer',
            body: widget.savedOnly
                ? 'Save a post from the Wall to find it here.'
                : 'No prayers in this topic yet. Create a local post with your own paper and stickers.',
            action: widget.savedOnly
                ? null
                : ActionButton('Create post',
                    onTap: () => openPostComposer(context))),
      for (final p in items)
        Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: SocialPostCard(p, key: ValueKey(p.id))),
    ]);
  }
}

class SocialPostCard extends ConsumerWidget {
  const SocialPostCard(this.post, {super.key});
  final WallPost post;
  Future<void> delete(BuildContext context, WidgetRef ref) async {
    final yes = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
                title: const Text('Delete your local post?'),
                content: const Text('This removes the post from this device.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(c, false),
                      child: const Text('Keep post')),
                  TextButton(
                      onPressed: () => Navigator.pop(c, true),
                      child: const Text('Delete'))
                ]));
    if (yes == true) await ref.read(storeProvider).deletePost(post.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = Theme.of(context).colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 0, 12),
          child: Row(children: [
            CircleAvatar(
                radius: 20,
                backgroundColor: tint(
                    context,
                    post.topic == 'Family'
                        ? 'peach'
                        : post.topic == 'Peace'
                            ? 'blue'
                            : 'lilac'),
                child: post.local
                    ? const Icon(CupertinoIcons.person_fill, size: 22)
                    : Art(stickerAsset(post.sticker) ?? doveAsset, size: 34)),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(post.name,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: s.onSurface)),
                  const SizedBox(height: 2),
                  Text(
                      post.local && !post.isPublic
                          ? 'Private prayer'
                          : post.topic,
                      style: const TextStyle(fontSize: 11))
                ])),
            if (post.local)
              PopupMenuButton<String>(
                  tooltip: 'Post options',
                  onSelected: (v) {
                    if (v == 'edit') {
                      openPostComposer(context, post: post);
                    } else if (v == 'archive') {
                      ref.read(storeProvider).archivePost(post, true);
                    } else {
                      delete(context, ref);
                    }
                  },
                  itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit post')),
                        PopupMenuItem(
                            value: 'archive', child: Text('Archive prayer')),
                        PopupMenuItem(
                            value: 'delete', child: Text('Delete post'))
                      ])
          ])),
      PostArtwork(post),
      const SizedBox(height: 6),
      Row(children: [
        IconButton(
            tooltip: storeHasPrayer(ref, post)
                ? 'In your prayers'
                : 'Add to my prayers',
            onPressed: storeHasPrayer(ref, post)
                ? null
                : () async {
                    final ok =
                        await ref.read(storeProvider).addPostToPrayers(post);
                    if (context.mounted && !ok) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Could not add prayer. Try again.')));
                    }
                  },
            icon: Icon(
                storeHasPrayer(ref, post)
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.plus_circle,
                size: 22)),
        Pressable(
            onTap: () => ref.read(storeProvider).pray(post),
            padding: const EdgeInsets.fromLTRB(4, 12, 12, 12),
            child: Row(children: [
              AnimatedGlyph(
                  active: post.prayed,
                  icon: CupertinoIcons.heart,
                  selectedIcon: CupertinoIcons.heart_fill,
                  color: post.prayed ? s.primary : s.onSurface,
                  size: 22),
              const SizedBox(width: 8),
              Text(post.prayed ? 'Prayed' : 'I prayed',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: post.prayed ? s.primary : s.onSurface))
            ])),
        Expanded(
            child: Text('${post.count} prayers',
                style: const TextStyle(fontSize: 11))),
        IconButton(
            tooltip: 'Copy prayer',
            onPressed: () async {
              await Clipboard.setData(
                  ClipboardData(text: '${post.title}\n\n${post.body}'));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Prayer text copied')));
              }
            },
            icon: const Icon(CupertinoIcons.paperplane, size: 21)),
        IconButton(
            tooltip: post.saved ? 'Unsave post' : 'Save post',
            onPressed: () =>
                ref.read(storeProvider).changePostState(post, save: true),
            icon: AnimatedGlyph(
                active: post.saved,
                icon: CupertinoIcons.bookmark,
                selectedIcon: CupertinoIcons.bookmark_fill,
                color: post.saved ? s.primary : s.onSurface,
                size: 21)),
      ]),
    ]);
  }
}

bool storeHasPrayer(WidgetRef ref, WallPost post) =>
    ref.watch(storeProvider).prayers.any((p) => p.id == post.id);
