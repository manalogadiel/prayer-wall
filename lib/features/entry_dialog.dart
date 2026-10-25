import 'package:flutter/material.dart';
import '../core/widgets.dart';

class EntryDialog extends StatefulWidget {
  const EntryDialog(
      {required this.journal,
      required this.onSave,
      this.initial = '',
      this.editing = false,
      super.key});
  final bool journal, editing;
  final String initial;
  final Future<bool> Function(String) onSave;
  @override
  State<EntryDialog> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  late final TextEditingController controller =
      TextEditingController(text: widget.initial);
  bool saving = false;
  String? error;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (saving) return;
    final text = controller.text.trim();
    if (text.isEmpty) {
      setState(() => error = 'Write a little before saving.');
      return;
    }
    setState(() {
      saving = true;
      error = null;
    });
    final ok = await widget.onSave(text);
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        saving = false;
        error = 'Could not save. Your text is still here; try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) => Dialog(
      child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        widget.journal
                            ? (widget.editing
                                ? 'Edit reflection'
                                : 'A little room to reflect')
                            : (widget.editing
                                ? 'Edit prayer'
                                : 'What’s on your heart?'),
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(widget.journal
                        ? 'Private, and saved on this device.'
                        : 'A name, a hope, or something you’re carrying.'),
                    const SizedBox(height: 20),
                    TextField(
                        controller: controller,
                        autofocus: true,
                        maxLength: widget.journal ? 2000 : 120,
                        minLines: widget.journal ? 6 : 2,
                        maxLines: widget.journal ? 10 : 4,
                        textCapitalization: TextCapitalization.sentences,
                        enabled: !saving,
                        decoration: InputDecoration(
                            labelText: widget.journal
                                ? 'Your reflection'
                                : 'Your prayer',
                            alignLabelWithHint: true)),
                    if (error != null)
                      Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Semantics(
                              liveRegion: true,
                              child: Text(error!,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .error)))),
                    const SizedBox(height: 12),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(
                          onPressed:
                              saving ? null : () => Navigator.pop(context),
                          child: const Text('Cancel')),
                      const SizedBox(width: 8),
                      Flexible(
                          child: ActionButton(
                              saving
                                  ? 'Saving…'
                                  : (widget.editing
                                      ? 'Save changes'
                                      : (widget.journal
                                          ? 'Save reflection'
                                          : 'Add prayer')),
                              onTap: saving ? null : save)),
                    ]),
                  ]))));
}
