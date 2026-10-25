# Prayer Wall — start here

This Flutter source package contains the local prayer wall, private prayer/journal/profile experience, original biblical art, Android widget source, retained references and current implementation plan.

1. Read PRODUCT.md and DESIGN.md for current behavior and normative implemented visual tokens; .impeccable/design.json extends the system and .impeccable/surfaces/social-wall.md describes this surface.
2. Read docs/MASTER_PLAN.md (version 1.6) and docs/IMPLEMENTATION_STATUS.md for canonical scope, current evidence and remaining work.
3. Read docs/superpowers/plans/2026-10-25-issues-implementation.md, docs/issues/2026-10-25/Issues.docx and extracted images 1–10 for the latest request. docs/UI-SOCIAL-REVAMP-DELIVERY.md records the cumulative delivery.
4. docs/REFERENCE_INDEX.md covers earlier owner reference/confirmation/bug screenshots. Reference 08 locks the Option A dove; historical toy/sheep candidates are not active identity.
5. Consult design/asset-manifest.json, design/prompts/ and PNG provenance before extending art. Optional character motion is separate in docs/MOTION_HANDOFF.md.

Wall launches first. Community contains Family / Young People / School Friends. Bible-inspired attached tabs replace pill switches. Profile places avatar left and name right, offers Prayer partners / Fellowship empty sheets, then Today / Journal / Saved. Settings appears only here. Keep the shared-coordinate black notched dock and white Create circle; icons rotate/scale without vertical bounce.

Publish saves on this device. Public/private is persisted audience intent, not a connected backend. The owner requested removing repeated sample/local UI labels and keeping the limitation in Settings. Preserve stable IDs, local data, expiry/archive/linkage semantics and recoverable failed saves. Do not rebuild the retired dashboard.

Run with a compatible Flutter SDK: flutter pub get, flutter test, flutter run. Final verification passed: 18 tests, zero analyzer issues, release web build (60.8s) and debug Android APK build (39.3s). Independent browser visual and sampled-source review is SHIP within the seven valid Issues captures, with no material fixes; see .impeccable/review/issues-finish-review.md. Check IMPLEMENTATION_STATUS.md before extending these claims to native runtime. Prior browser reviews are historical and scoped to their captures. ADB currently has no device; current native install/visual/widget acceptance is unverified.

Source-only archives must exclude SDK/caches, generated build output and Git metadata. Refresh archives after final source, documentation and verification; earlier archives predate the Issues milestone unless separately rebuilt. Machine-local previews are not portable. No public deployment, GitHub push or external messaging is authorized.
