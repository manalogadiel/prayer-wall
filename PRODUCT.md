# Product
<!-- impeccable:product-schema 1 -->

## Platform
android

## Stack
Existing Flutter/Dart app, also runnable in Chrome. Riverpod and SharedPreferences; native Android RemoteViews widget.

## Users
Christians keeping personal prayers and reflections, and exploring a social prayer wall and community spaces.

## Product Purpose
A prayer wall that feels like a personal, expressive social feed. People choose a post material and Bible-inspired stickers while keeping readable prayer text central.

## Operating Context
Wall is the default feed. Community contains spaces. Prayers holds the private checklist and Android widget. Profile begins with editable name, bio and optional device-local photo, followed by Today, journal access and saved posts. The Wall header avatar opens Profile; the approved dove is its no-photo fallback. Appearance and local data settings are accessible only in Profile.

## Capabilities and Constraints
Preserve existing personal prayer IDs, completion, answered state, widget inclusion, journal data and theme preferences. Current community content is a labeled preview; new composed posts are local on this device until a real backend is implemented. Never claim a public publish or real community membership. Local custom posts must persist, support editing/deletion, five material styles, sticker choice and placement. Keep failed input recoverable. Profile uses queued device-local persistence in profile_v1 and schemaVersion 4 JSON export; no account, photo upload or public identity service is implied.

## Brand Commitments
Prayer Wall name and owner-approved Option A clean graphic dove remain. Original source: docs/design-concepts/ollie-a-clean-graphic.png. Use meaningful original biblical assets in a matching soft graphic style. No decorative borders on buttons/cards. Essential buttons and selection controls are monochrome neutral/off-white, while content, category and community art remain colorful. Black notched mobile dock with raised white central create circle; each Prayer categories tile has a single illustration. User explicitly requests richer visuals and animated icon feedback, not a dashboard.

## Evidence on Hand
Existing master plan and nineteen retained owner reference/confirmation/bug screenshots. Current refinement source, 16 passing tests and clean analysis. Final status-overlay correction web release passed (115.4 seconds); browser review is SHIP within the four supplied Chrome views. Current Android APK attempt failed on a Google dependency download; older APK proof predates this refinement. No connected public backend or Android device testing evidence.

## Product Principles
Readable content wins over decoration. Private and public actions stay explicit. Prayed today is separate from Answered. Preserve data. No guilt streaks or spiritual scores.

## Current authorization
Owner explicitly requested auto-plan then auto-execute without questions or approval pauses. This supersedes skill approval/interview gates for this redesign. Choices left open are delegated to agent judgment. No external publication, GitHub push or messaging is authorized.


Latest device delivery (2026-10-25): current debug APK build passed (58.6s) and ADB replacement install succeeded on Samsung SM-A326B, user 0. Prior dependency-download failure is historical. Native visual/widget acceptance remains separate and unverified.
