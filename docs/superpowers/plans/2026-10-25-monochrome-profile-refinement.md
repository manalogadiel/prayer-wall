# Focused refinement plan - 2026-10-25

Owner request: remove category ghost copies; fix visible top background discontinuity; clarify profile-avatar meaning and prayer category title; use a black notched dock with raised white create control; Settings belongs only in Profile; Profile starts with actual editable personal info; essential controls are monochrome, colorful content remains.

## Evidence and root causes
- Each category tile currently renders two Art widgets, one faded/offset. Remove the redundant layer, not the illustration source.
- App dark canvas is blue-black #181A21 while the supplied phone preview status area is neutral charcoal. The own native/web overlay metadata does not control a third-party frame. Computer Use could not verify the original Chrome URL and stopped; no further Computer Use is permitted this turn. Match one neutral charcoal canvas across Flutter, native launch/overlays, CSS, theme metadata and browser bridge. Preserve safe content insets. Verify owned app layers; do not claim to have inspected or changed the external frame.
- Left avatar already navigates to Profile but lacks a profile model. Keep the dove as the no-photo fallback; add local editable name/about and optional photo using the official Flutter picker, never upload it.
- The current light dock and violet control fills conflict with the new references. Replace mobile dock with black rounded BottomAppBar plus a real notched raised white FAB. Keep four destinations, accessible names and selected state. Expanded layout keeps a monochrome rail.

## Steps
1. Retain the six new screenshots as references 13-18.
2. Add local profile data with safe queued writes and validation; profile editor preserves failed input and photo stays on device. Keep prior prayer/journal/post keys intact.
3. Remove category duplicate artwork, add Prayer categories title and one tile per actual topic. Keep selected state monochrome.
4. Build black notched mobile dock, raised off-white create button, neutral filled actions/chips/icons and readable focus feedback. Content palettes and approved dove remain.
5. Move every Settings entry into Profile. Profile begins with name, about and profile avatar; Today/Journal/Saved follow.
6. Unify top chrome/canvas colors across supported app layers. Verify renderer and document the unverified external frame.
7. Run relevant persistence/widget tests, analyze and web/Android builds. One batched phone/desktop light/dark review, one correction/confirmation if needed. Refresh canonical plan/status, reference index and handoff archive. Launch Chrome.

This is a bounded refinement of working flows. Owner's standing auto-plan/execute instruction overrides skill approval pauses. No remote backend, account, new art style or public publication is authorized.

## Implementation handoff status

Steps 1–6 are implemented in source. References 13–18 are indexed; single category art, Prayer categories heading, profile avatar routing, Profile-only Settings, editable local name/bio/photo, monochrome essential controls, notched black dock/raised create and matched owned canvas/overlays are recorded in the canonical docs and DESIGN system. `profile_v1` uses queued persistence and schemaVersion 4 export; official image_picker 1.2.4 is installed. No public account or photo upload added.

Step 7: final status-overlay correction web release passed (115.4 seconds), analysis rerun reported zero issues and all 16 tests passed again. Four current browser captures exist in .impeccable/review/refinement-*.png with copies in design/proofs/monochrome-refinement; independent browser finish review is SHIP for these four views with no material fixes, in .impeccable/review/refinement-finish-review.md. Current APK attempt failed retrieving androidx.collection:collection-ktx:1.4.2 from Google due unavailable host/network; earlier APK success is historical only. No phone/AVD/native capture exists, so native recapture remains open independently. External phone frame remains unverified after Computer Use stopped on URL verification failure. Archive refresh follows final review/documentation updates; do not infer an existing archive contains this refinement.

Continue from docs/IMPLEMENTATION_STATUS.md. Preserve earlier review reports and keep browser disposition separate from native acceptance.

Final runtime checks: all three dark theme-color metadata entries are #262626, navigation names are deduplicated, and keyboard-edited name Alex plus bio survived save/reload. A separate browser file-chooser check verified photo selection/save/reload/revert; native picker and lost-data recovery remain unverified. Local Chrome preview is running at http://127.0.0.1:8767 (session 77713); this is not a portable service.
