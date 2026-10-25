import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../core/store.dart';
import '../core/widgets.dart';
import '../app/theme.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({this.photo, this.size = 48, super.key});
  final String? photo;
  final double size;
  @override
  Widget build(BuildContext context) {
    Widget fallback() => Art(doveAsset, size: size * .85);
    Widget child = fallback();
    if (photo != null) {
      try {
        child = Image.memory(base64Decode(photo!),
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, error, stack) => fallback());
      } catch (_) {
        child = fallback();
      }
    }
    return ClipOval(
        child: Container(
            width: size,
            height: size,
            color: tint(context, 'lilac'),
            alignment: Alignment.center,
            child: child));
  }
}

Future<void> editProfile(BuildContext context, PrayerStore store,
        {String? recoveredPhoto}) =>
    showDialog<void>(
        context: context,
        builder: (_) => ProfileEditor(store, recoveredPhoto: recoveredPhoto));

class ProfileEditor extends StatefulWidget {
  const ProfileEditor(this.store, {this.recoveredPhoto, super.key});
  final PrayerStore store;
  final String? recoveredPhoto;
  @override
  State<ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  late final name = TextEditingController(text: widget.store.profileName);
  late final bio = TextEditingController(text: widget.store.profileBio);
  late String? photo = widget.recoveredPhoto ?? widget.store.profilePhoto;
  String? error;
  bool busy = false;
  @override
  void dispose() {
    name.dispose();
    bio.dispose();
    super.dispose();
  }

  Future<void> choosePhoto() async {
    setState(() => busy = true);
    try {
      final file = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxWidth: 640,
          maxHeight: 640,
          imageQuality: 80,
          requestFullMetadata: false);
      if (file != null) {
        final bytes = await file.readAsBytes();
        if (bytes.length > 1024 * 1024) throw StateError('size');
        if (mounted) {
          setState(() {
            photo = base64Encode(bytes);
            error = null;
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => error =
            'Choose a photo smaller than 1 MB. Your current picture is kept.');
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> save() async {
    setState(() {
      busy = true;
      error = null;
    });
    final ok = await widget.store.saveProfile(name.text, bio.text, photo);
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      setState(() {
        busy = false;
        error = widget.store.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
          title: const Text('Edit profile'),
          content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                    Center(child: ProfileAvatar(photo: photo, size: 88)),
                    TextButton.icon(
                        onPressed: busy ? null : choosePhoto,
                        icon: const Icon(CupertinoIcons.photo),
                        label: const Text('Choose photo')),
                    if (photo != null)
                      TextButton(
                          onPressed:
                              busy ? null : () => setState(() => photo = null),
                          child: const Text('Use dove instead')),
                    const SizedBox(height: 12),
                    TextField(
                        controller: name,
                        maxLength: 60,
                        textCapitalization: TextCapitalization.words,
                        decoration:
                            const InputDecoration(labelText: 'Your name')),
                    const SizedBox(height: 12),
                    TextField(
                        controller: bio,
                        maxLength: 160,
                        minLines: 2,
                        maxLines: 4,
                        decoration: const InputDecoration(
                            labelText: 'About you (optional)')),
                    const Text('Your profile and photo stay on this device.',
                        style: TextStyle(fontSize: 12)),
                    if (error != null)
                      Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(error!)),
                  ]))),
          actions: [
            TextButton(
                onPressed: busy ? null : () => Navigator.pop(context),
                child: const Text('Cancel')),
            ActionButton(busy ? 'Saving…' : 'Save profile',
                onTap: busy ? null : save)
          ]);
}
