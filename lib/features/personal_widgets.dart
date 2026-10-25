import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/store.dart';
import '../core/widgets.dart';
import '../app/theme.dart';

class PrayerRow extends ConsumerWidget {
  const PrayerRow(this.item, {this.onEdit, this.compact = false, super.key});
  final PrayerItem item;
  final VoidCallback? onEdit;
  final bool compact;
  Future<void> remove(BuildContext context, WidgetRef ref) async {
    final yes = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
                title: const Text('Delete this prayer?'),
                content: Text(item.title),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(c, false),
                      child: const Text('Keep prayer')),
                  TextButton(
                      onPressed: () => Navigator.pop(c, true),
                      child: const Text('Delete'))
                ]));
    if (yes != true) return;
    final ok =
        await ref.read(storeProvider).changePrayer('delete', id: item.id);
    if (!context.mounted || !ok) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Prayer deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () =>
                ref.read(storeProvider).changePrayer('add', item: item))));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(storeProvider);
    final s = Theme.of(context).colorScheme;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Semantics(
              label:
                  '${item.title}, ${item.done ? 'prayed today' : 'not prayed today'}',
              child: Checkbox(
                  value: item.done,
                  onChanged: store.loadFailed
                      ? null
                      : (_) => store.changePrayer('toggle', id: item.id))),
          const SizedBox(width: 4),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title,
                            style: TextStyle(
                                fontSize: 15,
                                height: 1.4,
                                fontWeight: FontWeight.w500,
                                color: s.onSurface)),
                        const SizedBox(height: 3),
                        Text(
                            item.answered
                                ? 'Answered'
                                : item.done
                                    ? 'Prayed today'
                                    : 'In your prayers',
                            style: TextStyle(
                                fontSize: 12,
                                color: item.done
                                    ? s.primary
                                    : s.onSurfaceVariant)),
                      ]))),
          if (!compact)
            PopupMenuButton<String>(
                tooltip: 'Prayer options',
                icon: const Icon(CupertinoIcons.ellipsis, size: 22),
                onSelected: (v) {
                  if (v == 'edit') onEdit?.call();
                  if (v == 'delete') remove(context, ref);
                  if (v == 'answer' || v == 'pin') {
                    store.changePrayer(v, id: item.id);
                  }
                },
                itemBuilder: (_) => [
                      const PopupMenuItem(
                          value: 'edit', child: Text('Edit prayer')),
                      PopupMenuItem(
                          value: 'answer',
                          child: Text(item.answered
                              ? 'Move to active'
                              : 'Mark answered')),
                      PopupMenuItem(
                          value: 'pin',
                          child: Text(item.pinned
                              ? 'Remove from widget'
                              : 'Include in widget')),
                      const PopupMenuItem(
                          value: 'delete', child: Text('Delete prayer')),
                    ]),
        ]));
  }
}

class WidgetPreview extends ConsumerWidget {
  const WidgetPreview({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(storeProvider);
    final rows =
        store.prayers.where((p) => p.pinned && !p.answered).take(3).toList();
    return Surface(
        color: tint(context, 'lilac'),
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Text('A moment to pray',
                    style: Theme.of(context).textTheme.titleMedium)),
            const Art(doveAsset, size: 52)
          ]),
          if (rows.isEmpty)
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Your included prayers will appear here.')),
          for (final p in rows) PrayerRow(p, compact: true),
          const SizedBox(height: 8),
          Text(
              '${rows.where((p) => p.done).length} of ${rows.length} prayed today',
              style: Theme.of(context).textTheme.bodySmall),
        ]));
  }
}

class FocusPrayerDialog extends ConsumerStatefulWidget {
  const FocusPrayerDialog(this.item, {super.key});
  final PrayerItem item;
  @override
  ConsumerState<FocusPrayerDialog> createState() => _FocusPrayerDialogState();
}

class _FocusPrayerDialogState extends ConsumerState<FocusPrayerDialog> {
  bool saving = false;
  String? error;
  Future<void> mark() async {
    if (saving) return;
    setState(() {
      saving = true;
      error = null;
    });
    final store = ref.read(storeProvider);
    // Another surface may already have completed the prayer while this was open.
    final matches = store.prayers.where((p) => p.id == widget.item.id);
    final ok = matches.isNotEmpty &&
        (matches.first.done ||
            await store.changePrayer('toggle', id: widget.item.id));
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      setState(() {
        saving = false;
        error = 'Could not save this change. Try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) => Dialog(
      child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                if (MediaQuery.textScalerOf(context).scale(1) < 1.5)
                  const Art(doveAsset, size: 96),
                const SizedBox(height: 16),
                Text('A moment to pray',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Text(widget.item.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 24),
                if (error != null)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Semantics(liveRegion: true, child: Text(error!))),
                ActionButton(saving ? 'Saving…' : 'Prayed today',
                    icon: CupertinoIcons.check_mark,
                    onTap: saving ? null : mark),
                TextButton(
                    onPressed: saving ? null : () => Navigator.pop(context),
                    child: const Text('Close')),
              ]))));
}
