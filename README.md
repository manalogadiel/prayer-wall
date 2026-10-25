# Prayer Wall

Flutter/Dart prayer app with a local social wall, personal prayers/journal and Android widget source. Wall launches first; Community / Prayers / Profile complete navigation. Community content is a labeled sample, and composed posts/profile/photo stay on this device. No connected public authentication or backend is claimed.

Start with [START_HERE.md](START_HERE.md), [canonical plan](docs/MASTER_PLAN.md) and [current status](docs/IMPLEMENTATION_STATUS.md). The latest refinement adds neutral controls, black notched dock, single-art Prayer categories and editable Profile; colorful content and approved dove remain. Settings lives only in Profile.

## Run

```sh
flutter pub get
flutter test
flutter run
```

Use a compatible Flutter SDK and platform tooling; preserve the existing Android project. See status for exact verification/build limits. Native Android visual, photo-picker and launcher-widget acceptance remain open; current APK retry is blocked by a Google dependency download failure. Backend/release milestones are separate work.
