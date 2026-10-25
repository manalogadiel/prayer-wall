import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/store.dart';
import '../features/home.dart';
import 'theme.dart';
import 'browser_theme.dart';

class PrayerWallApp extends ConsumerWidget {
  const PrayerWallApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
        title: 'Prayer Wall',
        debugShowCheckedModeBanner: false,
        theme: prayerTheme(Brightness.light),
        darkTheme: prayerTheme(Brightness.dark),
        themeMode: ref.watch(storeProvider).mode,
        builder: (context, child) {
          syncBrowserTheme(Theme.of(context).brightness == Brightness.dark);
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: Theme.of(context).brightness == Brightness.dark
                  ? SystemUiOverlayStyle.light.copyWith(
                      statusBarColor: Theme.of(context).scaffoldBackgroundColor,
                      systemNavigationBarColor: Colors.transparent,
                      systemNavigationBarDividerColor: Colors.transparent,
                      systemStatusBarContrastEnforced: false,
                      systemNavigationBarContrastEnforced: false)
                  : SystemUiOverlayStyle.dark.copyWith(
                      statusBarColor: Theme.of(context).scaffoldBackgroundColor,
                      systemNavigationBarColor: Colors.transparent,
                      systemNavigationBarDividerColor: Colors.transparent,
                      systemStatusBarContrastEnforced: false,
                      systemNavigationBarContrastEnforced: false),
              child: child ?? const SizedBox.shrink());
        },
        home: const HomePage(),
      );
}
