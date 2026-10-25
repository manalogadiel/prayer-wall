import 'dart:convert';
import 'wall_post.dart';
export 'wall_post.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storeProvider = ChangeNotifierProvider((ref) => PrayerStore()..load());
const widgetChannel = MethodChannel('prayer_wall/widget');
bool get isAndroid =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
String todayKey() => DateTime.now().toIso8601String().substring(0, 10);

class PrayerItem {
  const PrayerItem(this.id, this.title,
      {this.date = '', this.answered = false, this.pinned = true});
  final String id, title, date;
  final bool answered, pinned;
  bool get done => date == todayKey();
  PrayerItem copy(
          {String? title, String? date, bool? answered, bool? pinned}) =>
      PrayerItem(id, title ?? this.title,
          date: date ?? this.date,
          answered: answered ?? this.answered,
          pinned: pinned ?? this.pinned);
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date,
        'answered': answered,
        'pinned': pinned
      };
  factory PrayerItem.fromJson(Map<String, dynamic> j) =>
      PrayerItem(j['id'] as String, j['title'] as String,
          date: j['date'] as String? ?? '',
          answered: j['answered'] as bool? ?? false,
          pinned: j['pinned'] as bool? ?? true);
}

class JournalEntry {
  const JournalEntry(this.id, this.body, {this.createdAt, this.updatedAt});
  final String id, body;
  final DateTime? createdAt, updatedAt;
  Map<String, dynamic> toJson() => {
        'id': id,
        'body': body,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String()
      };
  factory JournalEntry.fromJson(Map<String, dynamic> j) =>
      JournalEntry(j['id'] as String, j['body'] as String,
          createdAt: DateTime.tryParse(j['createdAt'] as String? ?? ''),
          updatedAt: DateTime.tryParse(j['updatedAt'] as String? ?? ''));
}

class PrayerStore extends ChangeNotifier {
  bool ready = false, loadFailed = false;
  String? error;
  ThemeMode mode = ThemeMode.system;
  String profileName = '', profileBio = '';
  String? profilePhoto;
  List<PrayerItem> prayers = [];
  List<JournalEntry> journal = [];
  Set<String> joined = {};
  final posts = [
    WallPost(
        'Sarah M.',
        'SM',
        'Family',
        'A little strength for my mom',
        'My mom starts a new round of treatment this week. Praying for rest, courage, and a few ordinary, happy moments together.',
        24,
        design: PostDesign.sticky,
        sticker: StickerKind.lamb),
    WallPost(
        'Someone in our community',
        '♡',
        'Peace',
        'Learning to trust the waiting',
        'I’m in a season of uncertainty about work. Please pray that I can be present today and trust God with what comes next.',
        18,
        design: PostDesign.paper,
        sticker: StickerKind.boat,
        backgroundSticker: true),
    WallPost(
        'Daniel R.',
        'DR',
        'Gratitude',
        'Home, and so thankful',
        'Dad is finally home from the hospital. Thank you for every prayer and kind word. We are taking it one day at a time.',
        42,
        answered: true,
        design: PostDesign.formal,
        sticker: StickerKind.bread),
    WallPost(
        'Prayer Wall',
        'PW',
        'Hope',
        'For the next beginning',
        'For anyone stepping into a new season: a prayer for courage, wise choices, and people to walk beside you.',
        0,
        design: PostDesign.wall,
        sticker: StickerKind.ark),
    WallPost(
        'A prayer from the community',
        'PW',
        'Hope',
        'A little light for today',
        'Please pray for clarity as I decide what comes next. One honest step at a time.',
        0,
        design: PostDesign.normal,
        sticker: StickerKind.lamp),
  ];
  List<WallPost> localPosts = [];
  Map<String, dynamic> _wallState = {};
  List<WallPost> get feed => [...localPosts, ...posts];
  // Reloads and writes share a queue; resume cannot replace a newer edit.
  Future<void> _pending = Future.value();
  Future<T> _serial<T>(Future<T> Function() operation) {
    final result = _pending.then((_) => operation());
    _pending = result.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return result;
  }

  List<PrayerItem> _decode(String? raw) => raw == null
      ? []
      : (jsonDecode(raw) as List)
          .map((j) => PrayerItem.fromJson(Map<String, dynamic>.from(j)))
          .toList();
  Future<void> load() => _serial(() async {
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.reload();
          final nextMode = ThemeMode.values.firstWhere(
              (m) => m.name == prefs.getString('theme'),
              orElse: () => ThemeMode.system);
          final raw = isAndroid
              ? await widgetChannel.invokeMethod<String>('load')
              : prefs.getString('prayers');
          final nextPrayers = _decode(raw);
          final journalRaw = prefs.getString('journal_v2');
          final nextJournal = journalRaw == null
              ? (prefs.getStringList('journal') ?? [])
                  .asMap()
                  .entries
                  .map((e) => JournalEntry('legacy-${e.key}', e.value))
                  .toList()
              : (jsonDecode(journalRaw) as List)
                  .map((j) =>
                      JournalEntry.fromJson(Map<String, dynamic>.from(j)))
                  .toList();
          // Keep the original strings as a migration backup; historical dates stay unknown.
          if (journalRaw == null &&
              nextJournal.isNotEmpty &&
              !await prefs.setString('journal_v2',
                  jsonEncode(nextJournal.map((e) => e.toJson()).toList()))) {
            throw StateError('migration');
          }
          final nextPosts =
              (jsonDecode(prefs.getString('wall_posts_v1') ?? '[]') as List)
                  .map((j) => WallPost.fromJson(Map<String, dynamic>.from(j)))
                  .toList();
          final nextWallState = Map<String, dynamic>.from(
              jsonDecode(prefs.getString('wall_state_v1') ?? '{}'));
          final profile =
              jsonDecode(prefs.getString('profile_v1') ?? '{}') as Map;
          profileName = profile['name'] as String? ?? '';
          profileBio = profile['bio'] as String? ?? '';
          profilePhoto = profile['photo'] as String?;
          localPosts = nextPosts;
          _wallState = nextWallState;
          for (final post in feed) {
            final state =
                Map<String, dynamic>.from(_wallState[post.id] as Map? ?? {});
            post.prayed = state['prayed'] == true;
            post.saved = state['saved'] == true;
            post.count = post.baseCount + (post.prayed ? 1 : 0);
          }
          prayers = nextPrayers;
          journal = nextJournal;
          joined = (prefs.getStringList('joined') ?? []).toSet();
          mode = nextMode;
          loadFailed = false;
          error = null;
        } catch (_) {
          loadFailed = true;
          error =
              'Your saved content could not be loaded. Try again before making changes.';
        }
        ready = true;
        notifyListeners();
      });
  Future<bool> saveProfile(String name, String bio, String? photo) =>
      _serial(() async {
        if (!ready || loadFailed) return false;
        try {
          if (name.trim().length > 60 ||
              bio.trim().length > 160 ||
              (photo != null && base64Decode(photo).length > 1024 * 1024)) {
            throw ArgumentError('profile');
          }
          final prefs = await SharedPreferences.getInstance();
          if (!await prefs.setString(
              'profile_v1',
              jsonEncode(
                  {'name': name.trim(), 'bio': bio.trim(), 'photo': photo}))) {
            throw StateError('save');
          }
          profileName = name.trim();
          profileBio = bio.trim();
          profilePhoto = photo;
          error = null;
          notifyListeners();
          return true;
        } catch (_) {
          error =
              'Your profile could not be saved. Keep your changes and try again.';
          notifyListeners();
          return false;
        }
      });
  Future<bool> changePrayer(String action, {PrayerItem? item, String? id}) =>
      _serial(() async {
        if (!ready || loadFailed) return false;
        try {
          if (item != null &&
              (item.title.trim().isEmpty || item.title.trim().length > 120)) {
            throw ArgumentError('title');
          }
          if (isAndroid) {
            final raw = await widgetChannel.invokeMethod<String>(
                action, {'id': id, 'item': item?.toJson()});
            if (raw == null) throw StateError('empty response');
            prayers = _decode(raw);
          } else {
            final next = [...prayers];
            final i = next.indexWhere((p) => p.id == id);
            if (action == 'add' &&
                item != null &&
                !next.any((p) => p.id == item.id)) {
              next.add(item.copy(title: item.title.trim()));
            }
            if (i >= 0) {
              final p = next[i];
              if (action == 'toggle') {
                next[i] = p.copy(date: p.done ? '' : todayKey());
              }
              if (action == 'answer') next[i] = p.copy(answered: !p.answered);
              if (action == 'pin') next[i] = p.copy(pinned: !p.pinned);
              if (action == 'edit' && item != null) {
                next[i] = p.copy(title: item.title.trim());
              }
              if (action == 'delete') next.removeAt(i);
            }
            final prefs = await SharedPreferences.getInstance();
            if (!await prefs.setString(
                'prayers', jsonEncode(next.map((p) => p.toJson()).toList()))) {
              throw StateError('save');
            }
            prayers = next;
          }
          error = null;
          notifyListeners();
          return true;
        } catch (_) {
          error =
              'That change could not be saved. Your previous content is still here. Try again.';
          notifyListeners();
          return false;
        }
      });
  Future<bool> saveJournal(String body, {JournalEntry? entry}) =>
      _serial(() async {
        if (!ready ||
            loadFailed ||
            body.trim().isEmpty ||
            body.trim().length > 2000) {
          return false;
        }
        final now = DateTime.now();
        final next = [...journal];
        if (entry == null) {
          next.insert(
              0,
              JournalEntry(now.microsecondsSinceEpoch.toString(), body.trim(),
                  createdAt: now, updatedAt: now));
        } else {
          final i = next.indexWhere((e) => e.id == entry.id);
          if (i < 0) return false;
          next[i] = JournalEntry(entry.id, body.trim(),
              createdAt: entry.createdAt, updatedAt: now);
        }
        return _persistJournal(next);
      });
  Future<bool> addJournal(String text) => saveJournal(text);
  Future<bool> deleteJournal(String id) => _serial(() async {
        if (!ready || loadFailed) return false;
        return _persistJournal(journal.where((e) => e.id != id).toList(),
            clearLegacyBackup: true);
      });
  Future<bool> _persistJournal(List<JournalEntry> next,
      {bool clearLegacyBackup = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!await prefs.setString(
          'journal_v2', jsonEncode(next.map((e) => e.toJson()).toList()))) {
        throw StateError('save');
      }
      // A deletion also clears the temporary migration copy after v2 is durable.
      if (clearLegacyBackup &&
          prefs.containsKey('journal') &&
          !await prefs.remove('journal')) {
        throw StateError('legacy cleanup');
      }
      journal = next;
      error = null;
      notifyListeners();
      return true;
    } catch (_) {
      error =
          'Your reflection could not be saved. Keep your text and try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> setTheme(ThemeMode value) => _serial(() async {
        try {
          final p = await SharedPreferences.getInstance();
          if (!await p.setString('theme', value.name)) throw StateError('save');
          mode = value;
          error = null;
          notifyListeners();
          return true;
        } catch (_) {
          error = 'Appearance could not be saved. Try again.';
          notifyListeners();
          return false;
        }
      });
  Future<bool> join(String name) => _serial(() async {
        if (!ready || loadFailed) return false;
        try {
          final next = {...joined};
          next.contains(name) ? next.remove(name) : next.add(name);
          final p = await SharedPreferences.getInstance();
          if (!await p.setStringList('joined', next.toList())) {
            throw StateError('save');
          }
          joined = next;
          error = null;
          notifyListeners();
          return true;
        } catch (_) {
          error = 'Your sample circle selection could not be saved. Try again.';
          notifyListeners();
          return false;
        }
      });
  Future<bool> savePost(WallPost post) => _serial(() async {
        if (!ready ||
            loadFailed ||
            !post.local ||
            post.title.trim().isEmpty ||
            post.body.trim().isEmpty ||
            post.title.length > 120 ||
            post.body.length > 1000 ||
            !['Family', 'Peace', 'Gratitude', 'Hope'].contains(post.topic)) {
          return false;
        }
        try {
          final next = [...localPosts];
          final i = next.indexWhere((p) => p.id == post.id);
          if (i >= 0) {
            next[i] = post;
          } else {
            next.insert(0, post);
          }
          final prefs = await SharedPreferences.getInstance();
          if (!await prefs.setString('wall_posts_v1',
              jsonEncode(next.map((p) => p.toJson()).toList()))) {
            throw StateError('save');
          }
          localPosts = next;
          error = null;
          notifyListeners();
          return true;
        } catch (_) {
          error = 'Your post could not be saved. Keep your text and try again.';
          notifyListeners();
          return false;
        }
      });
  Future<bool> deletePost(String id) => _serial(() async {
        if (!ready || loadFailed) return false;
        try {
          final next = localPosts.where((p) => p.id != id).toList();
          final prefs = await SharedPreferences.getInstance();
          if (!await prefs.setString('wall_posts_v1',
              jsonEncode(next.map((p) => p.toJson()).toList()))) {
            throw StateError('save');
          }
          localPosts = next;
          error = null;
          notifyListeners();
          return true;
        } catch (_) {
          error = 'Could not delete this local post. Try again.';
          notifyListeners();
          return false;
        }
      });
  Future<bool> changePostState(WallPost post, {bool save = false}) =>
      _serial(() async {
        if (!ready || loadFailed) return false;
        try {
          final matches = feed.where((p) => p.id == post.id);
          if (matches.isEmpty) return false;
          final current = matches.first;
          final next = Map<String, dynamic>.from(_wallState);
          final prayed = save ? current.prayed : !current.prayed;
          final saved = save ? !current.saved : current.saved;
          next[current.id] = {'prayed': prayed, 'saved': saved};
          final prefs = await SharedPreferences.getInstance();
          if (!await prefs.setString('wall_state_v1', jsonEncode(next))) {
            throw StateError('save');
          }
          _wallState = next;
          current.prayed = prayed;
          current.saved = saved;
          current.count = current.baseCount + (prayed ? 1 : 0);
          error = null;
          notifyListeners();
          return true;
        } catch (_) {
          error = 'Could not save this action. Try again.';
          notifyListeners();
          return false;
        }
      });
  Future<bool> pray(WallPost post) => changePostState(post);

  String exportData() => const JsonEncoder.withIndent('  ').convert({
        'schemaVersion': 4,
        'profile': {
          'name': profileName,
          'bio': profileBio,
          'photo': profilePhoto
        },
        'localPosts': localPosts.map((p) => p.toJson()).toList(),
        'postStates': _wallState,
        'exportedAt': DateTime.now().toIso8601String(),
        'prayers': prayers.map((p) => p.toJson()).toList(),
        'journal': journal.map((j) => j.toJson()).toList()
      });
}
