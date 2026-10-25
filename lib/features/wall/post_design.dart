import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/store.dart';
import '../../core/widgets.dart';

String designLabel(PostDesign d) => switch (d) {
      PostDesign.sticky => 'Sticky note',
      PostDesign.paper => 'Paper',
      PostDesign.formal => 'Formal',
      PostDesign.normal => 'Normal',
      PostDesign.wall => 'Wall',
    };
String stickerLabel(StickerKind s) => switch (s) {
      StickerKind.none => 'None',
      StickerKind.dove => 'Hope dove',
      StickerKind.boat => 'Calm waters',
      StickerKind.bread => 'Daily bread',
      StickerKind.journal => 'Reflection',
      StickerKind.lamp => 'Guiding light',
      StickerKind.lamb => 'Little flock',
      StickerKind.ark => 'New beginnings',
    };
String? stickerAsset(StickerKind s) => switch (s) {
      StickerKind.none => null,
      StickerKind.dove => doveAsset,
      StickerKind.boat => boatAsset,
      StickerKind.bread => 'assets/illustrations/objects/loaves_fish_v001.png',
      StickerKind.journal => journalAsset,
      StickerKind.lamp => 'assets/illustrations/objects/lamp_v001.png',
      StickerKind.lamb => 'assets/illustrations/characters/lamb_v001.png',
      StickerKind.ark => 'assets/illustrations/objects/ark_v001.png',
    };
Color postColor(BuildContext c, PostDesign d) {
  final dark = Theme.of(c).brightness == Brightness.dark;
  return switch (d) {
    PostDesign.sticky => tint(c, 'butter'),
    PostDesign.paper => Color(dark ? 0xFF273540 : 0xFFEDF4FB),
    PostDesign.formal => Color(dark ? 0xFF302C40 : 0xFFECE7F6),
    PostDesign.wall => Color(dark ? 0xFF293C33 : 0xFFDDECE0),
    PostDesign.normal => Theme.of(c).colorScheme.surface,
  };
}

class PostArtwork extends StatelessWidget {
  const PostArtwork(this.post, {this.preview = false, super.key});
  final WallPost post;
  final bool preview;
  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme.copyWith(
        onSurface: post.colorValue == null
            ? Theme.of(context).colorScheme.onSurface
            : const Color(0xFF25262B));
    final path = stickerAsset(post.sticker);
    final large = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final radius = post.design == PostDesign.sticky ? 5.0 : 22.0;
    return Container(
        decoration: BoxDecoration(
            color: post.colorValue == null
                ? postColor(context, post.design)
                : Color(post.colorValue!),
            borderRadius: BorderRadius.circular(radius),
            boxShadow: post.design == PostDesign.sticky
                ? [
                    BoxShadow(
                        color: tint(context, 'butter').withValues(alpha: .3),
                        offset: const Offset(0, 7),
                        blurRadius: 18)
                  ]
                : null),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: CustomPaint(
                painter: MaterialPainter(
                    post.design, s.onSurface.withValues(alpha: .06)),
                child: Stack(children: [
                  if (post.backgroundSticker && path != null)
                    Positioned(
                        right: -10,
                        bottom: -12,
                        child: Opacity(
                            opacity:
                                Theme.of(context).brightness == Brightness.dark
                                    ? .13
                                    : .16,
                            child: Transform.rotate(
                                angle: -.10,
                                child: Art(path, size: large ? 120 : 200)))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(24,
                          post.design == PostDesign.sticky ? 36 : 24, 24, 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(post.title,
                                textAlign: post.design == PostDesign.formal
                                    ? TextAlign.center
                                    : TextAlign.start,
                                style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: preview ? 22 : 25,
                                    height: 1.15,
                                    letterSpacing: -.5,
                                    fontWeight: FontWeight.w600,
                                    color: s.onSurface)),
                            const SizedBox(height: 14),
                            Text(post.body,
                                style: TextStyle(
                                    fontSize: preview ? 14 : 16,
                                    height: 1.6,
                                    color: s.onSurface)),
                            const SizedBox(height: 16),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                      child: Text(
                                          post.answered
                                              ? 'An answered prayer'
                                              : post.topic,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: s.onSurface))),
                                  if (!post.backgroundSticker &&
                                      path != null &&
                                      !large)
                                    Transform.rotate(
                                        angle: .06,
                                        child:
                                            Art(path, size: preview ? 78 : 104))
                                  else
                                    const SizedBox(height: 26),
                                ]),
                          ])),
                  if (post.design == PostDesign.sticky)
                    Positioned(
                        top: -6,
                        left: 0,
                        right: 0,
                        child: Center(
                            child: Transform.rotate(
                                angle: -.05,
                                child: Container(
                                    width: 76,
                                    height: 24,
                                    color: const Color(0xFFC6A56B)
                                        .withValues(alpha: .75))))),
                ]))));
  }
}

class MaterialPainter extends CustomPainter {
  MaterialPainter(this.design, this.ink);
  final PostDesign design;
  final Color ink;
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = ink
      ..strokeWidth = 1;
    if (design == PostDesign.paper) {
      for (double y = 24; y < size.height; y += 28) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
      }
    }
    if (design == PostDesign.wall) {
      for (double y = 0; y < size.height; y += 48) {
        for (double x = (y ~/ 48).isEven ? -32 : -92;
            x < size.width;
            x += 132) {
          canvas.drawRRect(
              RRect.fromRectAndRadius(
                  Rect.fromLTWH(x, y, 126, 42), const Radius.circular(7)),
              p);
        }
      }
    }
    if (design == PostDesign.sticky) {
      final fold = Path()
        ..moveTo(size.width - 24, size.height)
        ..lineTo(size.width, size.height - 24)
        ..lineTo(size.width, size.height)
        ..close();
      canvas.drawPath(fold, Paint()..color = ink.withValues(alpha: .12));
    }
  }

  @override
  bool shouldRepaint(MaterialPainter old) =>
      old.design != design || old.ink != ink;
}
