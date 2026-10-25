import 'dart:js_interop';

@JS('prayerWallSetTheme')
external void _setTheme(JSBoolean dark);

void syncBrowserTheme(bool dark) => _setTheme(dark.toJS);
