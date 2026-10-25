enum PostDesign { sticky, paper, formal, normal, wall }

enum StickerKind { none, dove, boat, bread, journal, lamp, lamb, ark }

class WallPost {
  WallPost(this.name, this.initials, this.topic, this.title, this.body,
      this.baseCount,
      {String? id,
      this.answered = false,
      this.prayed = false,
      this.saved = false,
      this.design = PostDesign.normal,
      this.sticker = StickerKind.dove,
      this.backgroundSticker = false,
      this.local = false,
      this.createdAt,
      this.isPublic = true,
      this.archived = false,
      this.expiresAt,
      this.colorValue})
      : id = id ?? title.toLowerCase().replaceAll(RegExp('[^a-z0-9]+'), '-'),
        count = baseCount + (prayed ? 1 : 0);
  final String id, name, initials, topic, title, body;
  final int baseCount;
  final bool answered, backgroundSticker, local;
  final PostDesign design;
  final StickerKind sticker;
  final bool isPublic, archived;
  final int? colorValue;
  final DateTime? expiresAt;
  bool get visible =>
      !archived && (expiresAt == null || expiresAt!.isAfter(DateTime.now()));
  final DateTime? createdAt;
  int count;
  bool prayed, saved;
  WallPost edit(
          {required String title,
          required String body,
          required String topic,
          required PostDesign design,
          required StickerKind sticker,
          required bool backgroundSticker,
          bool? isPublic,
          bool? archived,
          int? colorValue,
          DateTime? expiresAt,
          bool clearExpiry = false}) =>
      WallPost(name, initials, topic, title, body, baseCount,
          id: id,
          answered: answered,
          prayed: prayed,
          saved: saved,
          design: design,
          sticker: sticker,
          backgroundSticker: backgroundSticker,
          local: local,
          createdAt: createdAt,
          isPublic: isPublic ?? this.isPublic,
          archived: archived ?? this.archived,
          colorValue: colorValue ?? this.colorValue,
          expiresAt: clearExpiry ? null : (expiresAt ?? this.expiresAt));
  Map<String, dynamic> toJson() => {
        'isPublic': isPublic,
        'archived': archived,
        'colorValue': colorValue,
        'expiresAt': expiresAt?.toIso8601String(),
        'id': id,
        'name': name,
        'initials': initials,
        'topic': topic,
        'title': title,
        'body': body,
        'baseCount': baseCount,
        'answered': answered,
        'design': design.name,
        'sticker': sticker.name,
        'backgroundSticker': backgroundSticker,
        'local': local,
        'createdAt': createdAt?.toIso8601String()
      };
  factory WallPost.fromJson(Map<String, dynamic> j) => WallPost(
      j['name'] as String,
      j['initials'] as String,
      j['topic'] as String,
      j['title'] as String,
      j['body'] as String,
      j['baseCount'] as int? ?? 0,
      id: j['id'] as String,
      answered: j['answered'] as bool? ?? false,
      design: PostDesign.values.firstWhere((v) => v.name == j['design'],
          orElse: () => PostDesign.normal),
      sticker: StickerKind.values.firstWhere((v) => v.name == j['sticker'],
          orElse: () => StickerKind.none),
      backgroundSticker: j['backgroundSticker'] as bool? ?? false,
      isPublic: j['isPublic'] as bool? ?? true,
      archived: j['archived'] as bool? ?? false,
      colorValue: j['colorValue'] as int?,
      expiresAt: DateTime.tryParse(j['expiresAt'] as String? ?? ''),
      local: true,
      createdAt: DateTime.tryParse(j['createdAt'] as String? ?? ''));
}
