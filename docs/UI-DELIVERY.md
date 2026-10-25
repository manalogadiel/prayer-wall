# Prayer Wall UI

Based on the GitHub `docs/PLAN.md`, retrieved October 24, 2026. This is a UI implementation with local persistence, not the Supabase launch milestones.

## Design

Violet #6956C9, lilac #F1EEFF, paper #F8F7FB, ink #302B40, sage #F0F3EB. Nunito is bundled under its included Open Font License. One storybook pasture illustration carries the personality; the rest of the interface stays quiet. Light/dark follows the system by default, with an optional appearance override. Native Android widget colors always follow Android's system theme.

## Working features

- Responsive community wall with clearly labeled sample posts, topic filtering, and session-only prayer toggles.
- Personal prayer list: add, delete, mark prayed today, undo, mark answered, and select which prayers appear in the widget. Local persistence; daily checks and answered status are separate.
- Private local journal, searchable sample circles, and locally remembered circle selections.
- Native Android home-screen widget: up to three pinned active prayers, direct check-off without launching Flutter, shared native persistence, and refresh when the app resumes. All placed instances refresh together. The header opens the app.
- Widget add button invokes the Android launcher pin request. If unsupported, use the launcher’s widget picker.

## Android check

Install the debug APK, add a prayer, tap **Add to home screen**, and accept the launcher prompt. Check a prayer on the home screen, reopen the app, and verify the check. Then undo in the app and verify the widget. Test with the app process closed, multiple widget instances, dark mode, and the next day. No Android device was attached during development; compilation was verified, launcher behavior still needs this device test.

Android can defer periodic widget refreshes. Date changes are interpreted immediately on the next tap or app refresh; passive midnight display refresh can lag behind the configured 30-minute update interval. Titles shown in the widget are visible on the unlocked home screen. Local data is not cloud-synced or encrypted by the app. App backup is disabled; uninstalling can remove saved prayers.

## Scope still pending

Supabase accounts/auth, real public posting and comments, live circles, moderation, cloud sync, FCM, production signing, store release, iOS widget integration. Do not treat sample community interactions as real submissions.

## Name ideas

- **Little Flock** — affectionate, sheep-friendly; Luke 12:32.
- **Still Waters** — calm and contemplative; Psalm 23:2.
- **Selah** — brief, reflective, familiar from the Psalms.
- **Olive & Amen** — a playful pairing of familiar biblical imagery and prayer language.
- **Manna** — daily provision; Exodus 16.

These are creative suggestions, not trademark or domain availability checks. Prayer Wall remains the app name.

## Asset provenance

`assets/pasture.png` was created using the built-in image generation tool, then copied into the Flutter assets and Android widget drawable resources.

Prompt: “Use case: illustration-story. Create a polished landscape illustration asset for a modern prayer app, 3:2 composition. Nostalgic mid-century children's Bible storybook gouache on softly textured paper. A very cute little ivory wool lamb with tiny dark eyes, soft peach cheeks, floppy ears, small rounded hooves, resting peacefully on a sage green hillside beside a winding pale blue still stream. A small olive tree on the right, tiny white meadow flowers, distant softly layered lavender hills and a small warm sun. Gentle dusty lavender sky. Restrained palette lilac #EAE6F6, sage #B9C8A6, milk white, muted olive, soft butter yellow. Beautiful confident hand-painted shapes, charming professional editorial illustration, not glossy 3D, no outlines, no text, no letters, no UI, no watermark. Lamb prominent in lower right half; upper left is calm open sky for UI text overlay. Comforting Psalm 23 pasture atmosphere. Fully opaque background.”

Native widget implementation follows Android's AppWidgetManager and explicit immutable PendingIntent patterns: https://developer.android.com/reference/android/appwidget/AppWidgetManager

## Run

`flutter pub get`, then `flutter run -d chrome` or `flutter run` with an Android device connected. Checks: `flutter analyze`, `flutter test`, `flutter build web`, `flutter build apk --debug`.


## Verified

Six Flutter tests pass, including persistence, undo, daily completion, shared live-preview state, feed filtering, rapid additions, and 320-pixel dark layouts. Flutter analysis reports no issues. Android debug APK and web release builds succeed. Browser inspection covered desktop and phone layouts, system dark mode, and persistence after reload. Native widget taps still require a device test.

