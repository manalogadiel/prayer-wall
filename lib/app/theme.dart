import 'package:flutter/material.dart';

const violet = Color(0xFF5941BE);
Color tint(BuildContext context, String role) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return switch (role) {
    'blue' => Color(dark ? 0xFF263B4A : 0xFFD5E8FB),
    'butter' => Color(dark ? 0xFF453B28 : 0xFFF7DEA0),
    'mint' => Color(dark ? 0xFF2D3E31 : 0xFFD9EBCB),
    'peach' => Color(dark ? 0xFF51352F : 0xFFF5BDB0),
    _ => Color(dark ? 0xFF39314E : 0xFFD5CBFF),
  };
}

ThemeData prayerTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
          seedColor: const Color(0xFF25262B), brightness: brightness)
      .copyWith(
    primary: dark ? const Color(0xFFF0EFEA) : const Color(0xFF25262B),
    onPrimary: dark ? const Color(0xFF25262B) : Colors.white,
    surface: dark ? const Color(0xFF303034) : Colors.white,
    onSurface: dark ? const Color(0xFFF4F3F8) : const Color(0xFF191B24),
    onSurfaceVariant: dark ? const Color(0xFFB8BCC9) : const Color(0xFF535661),
  );
  final base =
      ThemeData(useMaterial3: true, colorScheme: scheme, fontFamily: 'DM Sans');
  TextStyle heading(double size, FontWeight weight) => TextStyle(
      fontFamily: 'Outfit',
      fontSize: size,
      height: 1.12,
      fontWeight: weight,
      letterSpacing: -.7,
      color: scheme.onSurface);
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
  return base.copyWith(
    scaffoldBackgroundColor:
        dark ? const Color(0xFF262626) : const Color(0xFFF7F8F5),
    textTheme: base.textTheme.copyWith(
        headlineLarge: heading(34, FontWeight.w600),
        headlineMedium: heading(30, FontWeight.w600),
        headlineSmall: heading(26, FontWeight.w600),
        titleLarge: heading(22, FontWeight.w600),
        titleMedium: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 16,
            height: 1.35,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface),
        bodyLarge: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 16,
            height: 1.5,
            color: scheme.onSurface),
        bodyMedium: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 14,
            height: 1.5,
            color: scheme.onSurfaceVariant),
        bodySmall: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 12,
            height: 1.4,
            color: scheme.onSurfaceVariant)),
    filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFF4F4EF),
            foregroundColor: const Color(0xFF202126),
            minimumSize: const Size(48, 48),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: shape,
            textStyle: const TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w600,
                fontSize: 14))),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            minimumSize: const Size(48, 48), shape: shape)),
    iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48))),
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF30333E) : const Color(0xFFF0F1EE),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: scheme.primary, width: 2)),
        contentPadding: const EdgeInsets.all(16)),
    chipTheme: base.chipTheme.copyWith(
        side: BorderSide.none,
        showCheckmark: false,
        shape: const StadiumBorder(),
        backgroundColor: scheme.surface,
        selectedColor: scheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
    checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        side: BorderSide(color: scheme.onSurfaceVariant, width: 1.5)),
    dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface, showDragHandle: true),
    snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
  );
}
