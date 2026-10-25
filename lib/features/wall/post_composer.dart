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

const prayerColors = [
  0xFFF7DEA0,
  0xFFD5E8FB,
  0xFFD9EBCB,
  0xFFF5D3CC,
  0xFFE7DFF5,
  0xFFF1E8D8
];

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
  late bool isPublic = widget.existing?.isPublic ?? true;
  late String topic = widget.existing?.topic ?? 'Hope';
  late int? color = widget.existing?.colorValue;
  late DateTime? expiry = widget.existing?.expiresAt;
  late String duration = expiry == null ? 'Infinite' : 'Specific date';
  late final draftId =
      widget.existing?.id ?? 'local-${DateTime.now().microsecondsSinceEpoch}';
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
        ? 'Your prayer title'
        : title.text.trim();
    final b = body.text.trim().isEmpty && placeholder
        ? 'Your prayer appears here.'
        : body.text.trim();
    final old = widget.existing;
    final expires = switch (duration) {
      '1 day' => DateTime.now().add(const Duration(days: 1)),
      '1 week' => DateTime.now().add(const Duration(days: 7)),
      '1 month' => oneMonthFrom(DateTime.now()),
      'Specific date' => expiry,
      _ => null
    };
    return WallPost(
        ref.read(storeProvider).profileName.isEmpty
            ? 'You'
            : ref.read(storeProvider).profileName,
        'Y',
        topic,
        t,
        b,
        old?.baseCount ?? 0,
        id: draftId,
        local: true,
        createdAt: old?.createdAt ?? DateTime.now(),
        design: design,
        sticker: sticker,
        backgroundSticker: background,
        isPublic: isPublic,
        colorValue: color,
        archived: old?.archived ?? false,
        expiresAt: expires,
        prayed: old?.prayed ?? false,
        saved: old?.saved ?? false);
  }

  Future<void> save() async {
    if (saving) return;
    if (title.text.trim().isEmpty || body.text.trim().isEmpty) {
      setState(() => error = 'Add a title and your prayer.');
      return;
    }
    if (duration == 'Specific date' &&
        (expiry == null || !expiry!.isAfter(DateTime.now()))) {
      setState(() => error = 'Choose a future date.');
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
        error = 'Could not save. Your words are still here. Try again.';
      });
    }
  }

  Widget heading(String value) => Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(value, style: Theme.of(context).textTheme.titleMedium));
  @override
  Widget build(BuildContext context) => SizedBox(
      height: MediaQuery.sizeOf(context).height * .80,
      child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 12, 10),
                child: Row(children: [
                  Expanded(
                      child: Text(
                          widget.existing == null
                              ? 'Make it your prayer.'
                              : 'Edit your prayer',
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
                            child: IgnorePointer(
                                ignoring: saving,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      TextField(
                                          controller: title,
                                          enabled: !saving,
                                          maxLength: 120,
                                          onChanged: (_) => setState(() {}),
                                          decoration: const InputDecoration(
                                              labelText: 'Post title')),
                                      const SizedBox(height: 8),
                                      TextField(
                                          controller: body,
                                          enabled: !saving,
                                          minLines: 3,
                                          maxLines: 6,
                                          maxLength: 1000,
                                          onChanged: (_) => setState(() {}),
                                          decoration: const InputDecoration(
                                              labelText: 'Your prayer')),
                                      heading('Prayer topic'),
                                      BibleTabs(
                                          labels: const [
                                            'Hope',
                                            'Peace',
                                            'Family',
                                            'Gratitude'
                                          ],
                                          index: [
                                            'Hope',
                                            'Peace',
                                            'Family',
                                            'Gratitude'
                                          ].indexOf(topic),
                                          onChanged: (i) => setState(() =>
                                              topic = [
                                                'Hope',
                                                'Peace',
                                                'Family',
                                                'Gratitude'
                                              ][i])),
                                      heading('Visibility'),
                                      BibleTabs(
                                          labels: const ['Public', 'Private'],
                                          index: isPublic ? 0 : 1,
                                          onChanged: (i) => setState(
                                              () => isPublic = i == 0)),
                                      heading('Keep on the wall'),
                                      DropdownButtonFormField<String>(
                                          initialValue: duration,
                                          decoration: const InputDecoration(
                                              labelText: 'Duration'),
                                          items: [
                                            '1 day',
                                            '1 week',
                                            '1 month',
                                            'Specific date',
                                            'Infinite'
                                          ]
                                              .map((v) => DropdownMenuItem(
                                                  value: v, child: Text(v)))
                                              .toList(),
                                          onChanged: (v) =>
                                              setState(() => duration = v!)),
                                      if (duration == 'Specific date')
                                        TextButton.icon(
                                            icon: const Icon(
                                                CupertinoIcons.calendar),
                                            label: Text(expiry == null
                                                ? 'Choose date'
                                                : expiry!
                                                    .toLocal()
                                                    .toString()
                                                    .substring(0, 10)),
                                            onPressed: () async {
                                              final now = DateTime.now();
                                              final picked =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate: expiry !=
                                                                  null &&
                                                              expiry!
                                                                  .isAfter(now)
                                                          ? expiry!
                                                          : now
                                                              .add(
                                                                  const Duration(
                                                                      days: 1)),
                                                      firstDate:
                                                          DateTime(
                                                              now.year,
                                                              now.month,
                                                              now.day),
                                                      lastDate: now.add(
                                                          const Duration(
                                                              days: 3650)));
                                              if (picked != null && mounted) {
                                                setState(() => expiry =
                                                    DateTime(
                                                        picked.year,
                                                        picked.month,
                                                        picked.day,
                                                        23,
                                                        59,
                                                        59));
                                              }
                                            }),
                                      heading('A little meaning'),
                                      SizedBox(
                                          height:
                                              MediaQuery.textScalerOf(context)
                                                          .scale(1) >
                                                      1.4
                                                  ? 140
                                                  : 110,
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
                                                        selected:
                                                            sticker == kind,
                                                        onTap: () => setState(
                                                            () =>
                                                                sticker = kind),
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surfaceContainerLow,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
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
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          10))
                                                            ])));
                                              })),
                                      BibleTabs(
                                          labels: const [
                                            'Foreground',
                                            'Background'
                                          ],
                                          index: background ? 1 : 0,
                                          onChanged: (i) => setState(
                                              () => background = i == 1)),
                                      heading('Color'),
                                      Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            for (final value in prayerColors)
                                              Semantics(
                                                  selected: color == value,
                                                  child: IconButton(
                                                      tooltip:
                                                          'Color ${prayerColors.indexOf(value) + 1}',
                                                      style: IconButton.styleFrom(
                                                          backgroundColor:
                                                              Color(value),
                                                          foregroundColor:
                                                              const Color(
                                                                  0xFF25262B)),
                                                      onPressed: () => setState(
                                                          () => color = value),
                                                      icon: Icon(
                                                          color == value
                                                              ? CupertinoIcons
                                                                  .check_mark
                                                              : CupertinoIcons
                                                                  .circle_fill,
                                                          size: 18))),
                                            TextButton(
                                                onPressed: () => setState(
                                                    () => color = null),
                                                child: const Text('Original'))
                                          ]),
                                      heading('Choose your paper'),
                                      BibleTabs(
                                          labels: PostDesign.values
                                              .map(designLabel)
                                              .toList(),
                                          index: design.index,
                                          onChanged: (i) => setState(() =>
                                              design = PostDesign.values[i])),
                                      heading('Your preview'),
                                      PostArtwork(draft(placeholder: true),
                                          preview: true),
                                      if (error != null)
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: Semantics(
                                                liveRegion: true,
                                                child: Text(error!))),
                                      const SizedBox(height: 24),
                                    ])))))),
            SafeArea(
                top: false,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    child: SizedBox(
                        width: double.infinity,
                        child: ActionButton(saving ? 'Publishing…' : 'Publish',
                            onTap: saving ? null : save,
                            icon: CupertinoIcons.paperplane)))),
          ])));
}

DateTime oneMonthFrom(DateTime now) {
  final lastDay = DateTime(now.year, now.month + 2, 0).day;
  return DateTime(now.year, now.month + 1,
      now.day > lastDay ? lastDay : now.day, now.hour, now.minute, now.second);
}
