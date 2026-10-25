# Product
<!-- impeccable:product-schema 1 -->

## Platform
android

## Stack
Existing Flutter/Dart app, also runnable in Chrome. Riverpod and SharedPreferences; native Android RemoteViews widget.

## Users
Christians keeping personal prayers and reflections, and exploring a social prayer wall and community spaces.

## Product Purpose
A personal, expressive prayer wall with Bible-inspired art, five writing materials and readable live prayer text.

## Operating Context
Wall launches first; Wall / Community / Prayers / Profile are primary. Community has Family, Young People and School Friends with searchable Discover / My spaces. Prayers has Active / Answered / Archive. Profile places avatar left and editable name/bio right, followed by Prayer partners / Fellowship empty connection sheets and Today / Journal / Saved. Settings is available only in Profile.

## Capabilities and Constraints
Everything persists on this device. Public is the default composed-post audience field; it does not upload, authenticate or publish to another person. Private remains selectable. The Settings explanation carries this backend limitation; repeated sample/local badges were removed from feed, composer and community at the owner's request. No fabricated accounts, connection counts or real community membership claims.

Composer has title/body, topic below writing fields, audience, expiry (one day, one week, clamped calendar month, specific date or infinite), material directly above Preview, biblical sticker placement and curated pastel color. It occupies 80% viewport height with pinned Publish / Save changes footer. Posts keep stable IDs; saved edits update the matching prayer title without duplicate prayer rows. Other posts can be added through the plus action. Archive removes linked prayers from the widget; restoring clears expiry and does not automatically re-pin them. Daily completion remains distinct from Answered.

Preserve existing prayer/journal/profile/theme data and formats. wall_posts_v1 and prayer records use additive fields for audience, color, expiry, archive and linkage. Profile uses queued profile_v1 writes and schemaVersion 4 export; photo selection is device-local. Failed input remains recoverable. Backend, auth, cloud sync, moderation, comments and push are unimplemented.

## Brand Commitments
Prayer Wall and owner-approved Option A dove remain binding. Outfit headings, DM Sans body, original soft graphic biblical artwork and monochrome essential actions stay. Bible-inspired attached page tabs use butter selected fill; content remains colorful. No decorative card/button borders. Black notched mobile dock and raised white Create circle share a coordinate system. Icons rotate and scale without vertical bouncing and respect reduced motion.

## Evidence on Hand
Issues.docx and ten extracted images are retained under docs/issues/2026-10-25/. Current plan is docs/superpowers/plans/2026-10-25-issues-implementation.md. Final verification passed: 18 tests, zero analyzer issues, release web build (60.8s) and debug Android APK build (39.3s). Independent browser visual and sampled-source review is SHIP within the seven valid Issues captures, with no material fixes; see .impeccable/review/issues-finish-review.md. Consult docs/IMPLEMENTATION_STATUS.md for evidence boundaries. Previous 17-test dock pass, older browser SHIP reviews and prior Samsung install are historical and do not establish acceptance of the Issues changes. ADB currently lists no device; native visual/widget acceptance remains open.

## Product Principles
Readable content wins over decoration. Private and public intent stay explicit. Prayed today is separate from Answered. Preserve data. No guilt streaks or spiritual scores.

## Current authorization
Owner requested automatic planning and implementation without questions or approval pauses. No public deployment, GitHub push or external messaging is authorized.
