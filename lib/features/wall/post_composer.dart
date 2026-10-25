import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/store.dart';
import '../../core/widgets.dart';
import 'post_design.dart';

Future<bool?> openPostComposer(BuildContext context, {WallPost? post}) =>
    showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => PostComposer(existing: post));

class PostComposer extends ConsumerStatefulWidget {
  const PostComposer({this.existing, super.key});
  final WallPost? existing;
  @override
  ConsumerState<PostComposer> createState() => _PostComposerState();
}

class _PostComposerState extends ConsumerState<PostComposer> {
  late final title = TextEditingController(text: widget.existing?.title ?? '');
  late final body = TextEditingController(text: widget.existing?.body ?? '');
  late PostDesign design = widget.existing?.design ?? PostDesign.sticky;
  late StickerKind sticker = widget.existing?.sticker ?? StickerKind.dove;
  late bool background = widget.existing?.backgroundSticker ?? false;
  late String topic = widget.existing?.topic ?? 'Hope';
  bool saving = false;
  String? error;
  @override
  void dispose() {
    title.dispose();
    body.dispose();
    super.dispose();
  }

  WallPost draft({bool placeholder = false}) {
    final t = title.text.trim().isEmpty && placeholder
        ? 'What’s on your heart?'
        : title.text.trim();
    final b = body.text.trim().isEmpty && placeholder
        ? 'Your words belong here. Choose a paper, add a little meaning, and make this prayer your own.'
        : body.text.trim();
    return widget.existing?.edit(
            title: t,
            body: b,
            topic: topic,
            design: design,
            sticker: sticker,
            backgroundSticker: background) ??
        WallPost('You', 'Y', topic, t, b, 0,
            id: 'local-${DateTime.now().microsecondsSinceEpoch}',
            local: true,
            createdAt: DateTime.now(),
            design: design,
            sticker: sticker,
            backgroundSticker: background);
  }

  Future<void> save() async {
    if (saving) return;
    if (title.text.trim().isEmpty || body.text.trim().isEmpty) {
      setState(() => error = 'Add a title and your prayer before saving.');
      return;
    }
    setState(() {
      saving = true;
      error = null;
    });
    final ok = await ref.read(storeProvider).savePost(draft());
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        saving = false;
        error =
            'Could not save. Your words and design are still here. Try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return SizedBox(
        height: MediaQuery.sizeOf(context).height * .93,
        child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom),
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 12, 12),
                  child: Row(children: [
                    Expanded(
                        child: Text(
                            widget.existing == null
                                ? 'Make it your prayer.'
                                : 'Edit your post',
                            style: Theme.of(context).textTheme.headlineSmall)),
                    IconButton(
                        tooltip: 'Close composer',
                        onPressed: saving ? null : () => Navigator.pop(context),
                        icon: const Icon(CupertinoIcons.xmark))
                  ])),
              Expanded(
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                          child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 680),
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Text(
                                        'Only on this device. Public sharing is not connected.'),
                                    const SizedBox(height: 20),
                                    TextField(
                                        controller: title,
                                        enabled: !saving,
                                        onChanged: (_) => setState(() {}),
                                        maxLength: 120,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: const InputDecoration(
                                            labelText: 'Post title')),
                                    const SizedBox(height: 8),
                                    TextField(
                                        controller: body,
                                        enabled: !saving,
                                        onChanged: (_) => setState(() {}),
                                        minLines: 3,
                                        maxLines: 8,
                                        maxLength: 1000,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: const InputDecoration(
                                            labelText: 'Your prayer',
                                            alignLabelWithHint: true)),
                                    const SizedBox(height: 12),
                                    Text('Choose your paper',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    const SizedBox(height: 10),
                                    Wrap(spacing: 8, runSpacing: 8, children: [
                                      for (final d in PostDesign.values)
                                        ChoiceChip(
                                            label: Text(designLabel(d)),
                                            selected: design == d,
                                            onSelected: saving
                                                ? null
                                                : (_) =>
                                                    setState(() => design = d),
                                            labelStyle: TextStyle(
                                                color: design == d
                                                    ? s.onPrimary
                                                    : s.onSurface))
                                    ]),
                                    const SizedBox(height: 20),
                                    Text('A little meaning',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                        height: MediaQuery.textScalerOf(context)
                                                    .scale(1) >
                                                1.4
                                            ? 132
                                            : 106,
                                        child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                StickerKind.values.length,
                                            separatorBuilder: (_, __) =>
                                                const SizedBox(width: 8),
                                            itemBuilder: (_, i) {
                                              final kind =
                                                  StickerKind.values[i];
                                              final path = stickerAsset(kind);
                                              return SizedBox(
                                                  width: 84,
                                                  child: Pressable(
                                                      onTap: saving
                                                          ? null
                                                          : () => setState(() =>
                                                              sticker = kind),
                                                      selected: sticker == kind,
                                                      color: sticker == kind
                                                          ? s.primary
                                                              .withValues(
                                                                  alpha: .13)
                                                          : s
                                                              .surfaceContainerLow,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            if (path != null)
                                                              Art(path,
                                                                  size: 48)
                                                            else
                                                              const Icon(
                                                                  CupertinoIcons
                                                                      .clear,
                                                                  size: 40),
                                                            const SizedBox(
                                                                height: 4),
                                                            Text(
                                                                stickerLabel(
                                                                    kind),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        height:
                                                                            1.1))
                                                          ])));
                                            })),
                                    const SizedBox(height: 12),
                                    Wrap(spacing: 8, children: [
                                      ChoiceChip(
                                          label: const Text('Foreground'),
                                          selected: !background,
                                          onSelected: saving
                                              ? null
                                              : (_) => setState(
                                                  () => background = false),
                                          labelStyle: TextStyle(
                                              color: !background
                                                  ? s.onPrimary
                                                  : s.onSurface)),
                                      ChoiceChip(
                                          label: const Text('Background'),
                                          selected: background,
                                          onSelected: saving
                                              ? null
                                              : (_) => setState(
                                                  () => background = true),
                                          labelStyle: TextStyle(
                                              color: background
                                                  ? s.onPrimary
                                                  : s.onSurface))
                                    ]),
                                    const SizedBox(height: 20),
                                    Text('Prayer topic',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    const SizedBox(height: 8),
                                    Wrap(spacing: 8, runSpacing: 8, children: [
                                      for (final t in [
                                        'Hope',
                                        'Peace',
                                        'Family',
                                        'Gratitude'
                                      ])
                                        ChoiceChip(
                                            label: Text(t),
                                            selected: topic == t,
                                            onSelected: saving
                                                ? null
                                                : (_) =>
                                                    setState(() => topic = t),
                                            labelStyle: TextStyle(
                                                color: topic == t
                                                    ? s.onPrimary
                                                    : s.onSurface))
                                    ]),
                                    const SizedBox(height: 24),
                                    Text('Your preview',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    const SizedBox(height: 12),
                                    PostArtwork(draft(placeholder: true),
                                        preview: true),
                                    const SizedBox(height: 24),
                                    if (error != null)
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          child: Semantics(
                                              liveRegion: true,
                                              child: Text(error!,
                                                  style: TextStyle(
                                                      color: s.error)))),
                                  ]))))),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: SizedBox(
                      width: double.infinity,
                      child: ActionButton(
                          saving ? 'Saving…' : 'Save to my wall',
                          icon: CupertinoIcons.plus,
                          onTap: saving ? null : save))),
            ])));
  }
}
