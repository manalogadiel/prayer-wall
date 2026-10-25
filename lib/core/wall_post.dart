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
      this.createdAt})
      : id = id ?? title.toLowerCase().replaceAll(RegExp('[^a-z0-9]+'), '-'),
        count = baseCount + (prayed ? 1 : 0);
  final String id, name, initials, topic, title, body;
  final int baseCount;
  final bool answered, backgroundSticker, local;
  final PostDesign design;
  final StickerKind sticker;
  final DateTime? createdAt;
  int count;
  bool prayed, saved;
  WallPost edit(
          {required String title,
          required String body,
          required String topic,
          required PostDesign design,
          required StickerKind sticker,
          required bool backgroundSticker}) =>
      WallPost(name, initials, topic, title, body, baseCount,
          id: id,
          answered: answered,
          prayed: prayed,
          saved: saved,
          design: design,
          sticker: sticker,
          backgroundSticker: backgroundSticker,
          local: local,
          createdAt: createdAt);
  Map<String, dynamic> toJson() => {
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
      local: true,
      createdAt: DateTime.tryParse(j['createdAt'] as String? ?? ''));
}
