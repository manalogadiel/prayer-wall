import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../app/theme.dart';

const doveAsset = 'assets/illustrations/characters/dove_master_v002.png';
const boatAsset = 'assets/illustrations/objects/calm_boat_v001.png';
const journalAsset = 'assets/illustrations/objects/journal_v001.png';

class Art extends StatelessWidget {
  const Art(this.path, {this.size = 120, super.key});
  final String path;
  final double size;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
      child: Image.asset(path,
          width: size,
          height: size,
          fit: BoxFit.contain,
          cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).ceil()));
}

class Surface extends StatelessWidget {
  const Surface(
      {required this.child,
      this.color,
      this.padding = const EdgeInsets.all(20),
      this.radius = 24,
      super.key});
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final double radius;
  @override
  Widget build(BuildContext context) => Container(
      padding: padding,
      decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(radius)),
      child: child);
}

class Pressable extends StatefulWidget {
  const Pressable(
      {required this.child,
      required this.onTap,
      this.color,
      this.radius = 16,
      this.padding = EdgeInsets.zero,
      this.label,
      this.selected,
      super.key});
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final double radius;
  final EdgeInsetsGeometry padding;
  final String? label;
  final bool? selected;
  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool down = false;
  @override
  Widget build(BuildContext context) => AnimatedScale(
      scale: down && !MediaQuery.disableAnimationsOf(context) ? .97 : 1,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : Duration(milliseconds: down ? 90 : 180),
      curve: Curves.easeOutCubic,
      child: Material(
          color: widget.color ?? Colors.transparent,
          borderRadius: BorderRadius.circular(widget.radius),
          child: InkWell(
              onTap: widget.onTap,
              onHighlightChanged: (v) => setState(() => down = v),
              borderRadius: BorderRadius.circular(widget.radius),
              child: Semantics(
                  label: widget.label,
                  selected: widget.selected,
                  enabled: widget.onTap != null,
                  child:
                      Padding(padding: widget.padding, child: widget.child)))));
}

class ActionButton extends StatelessWidget {
  const ActionButton(this.label,
      {required this.onTap, this.icon, this.secondary = false, super.key});
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool secondary;
  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return Opacity(
        opacity: onTap == null ? .5 : 1,
        child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: secondary
                    ? null
                    : const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFFFEFA), Color(0xFFE9E9E3)]),
                color: secondary ? s.onSurface.withValues(alpha: .08) : null,
                boxShadow: secondary
                    ? null
                    : [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: .09),
                            blurRadius: 10,
                            offset: const Offset(0, 3))
                      ]),
            child: Pressable(
                onTap: onTap,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 20),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icon != null) ...[
                            Icon(icon,
                                size: 19,
                                color: secondary
                                    ? s.onSurface
                                    : const Color(0xFF202126)),
                            const SizedBox(width: 8)
                          ],
                          Flexible(
                              child: Text(label,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      height: 1.4,
                                      fontWeight: FontWeight.w600,
                                      color: secondary
                                          ? s.onSurface
                                          : const Color(0xFF202126)))),
                        ])))));
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {this.action, this.onTap, super.key});
  final String title;
  final String? action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        if (action != null) TextButton(onPressed: onTap, child: Text(action!)),
      ]));
}

class SmallTag extends StatelessWidget {
  const SmallTag(this.text, {this.role = 'mint', super.key});
  final String text, role;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: tint(context, role), borderRadius: BorderRadius.circular(30)),
      child: Text(text,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface)));
}

class EmptyView extends StatelessWidget {
  const EmptyView(
      {required this.title,
      required this.body,
      this.asset = doveAsset,
      this.action,
      super.key});
  final String title, body, asset;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Surface(
          child: Column(children: [
        Art(asset, size: 112),
        const SizedBox(height: 12),
        Text(title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 330),
            child: Text(body, textAlign: TextAlign.center)),
        if (action != null) ...[const SizedBox(height: 20), action!],
      ]));
}

class AnimatedGlyph extends StatefulWidget {
  const AnimatedGlyph(
      {required this.active,
      required this.icon,
      required this.selectedIcon,
      required this.color,
      this.size = 24,
      super.key});
  final bool active;
  final IconData icon, selectedIcon;
  final Color color;
  final double size;
  @override
  State<AnimatedGlyph> createState() => _AnimatedGlyphState();
}

class _AnimatedGlyphState extends State<AnimatedGlyph>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 240));
  @override
  void didUpdateWidget(AnimatedGlyph old) {
    super.didUpdateWidget(old);
    if (old.active != widget.active &&
        !MediaQuery.disableAnimationsOf(context) &&
        HardwareKeyboard.instance.logicalKeysPressed.isEmpty) {
      controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: controller,
      builder: (c, _) {
        final wave = MediaQuery.disableAnimationsOf(c)
            ? 0.0
            : math.sin(controller.value * math.pi);
        return Transform.translate(
            offset: Offset(0, -2 * wave),
            child: Transform.rotate(
                angle: .12 * wave,
                child: Transform.scale(
                    scale: 1 + .12 * wave,
                    child: Icon(
                        widget.active ? widget.selectedIcon : widget.icon,
                        size: widget.size,
                        color: widget.color))));
      });
}
