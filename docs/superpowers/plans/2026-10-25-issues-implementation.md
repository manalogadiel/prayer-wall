# Issues.docx implementation — 2026-10-25

Source: docs/issues/2026-10-25/Issues.docx and images1–10 retained unchanged. Owner explicitly requested analysis and implementation.

- Strengthen sticky-note tape contrast in light mode.
- Link created posts and personal prayer list by stable post ID; preserve existing prayer data and native widgets. Retry must reuse ID. Add others' posts without duplicates.
- Persist Public/Private visibility (Public default), expiry (day/week/calendar month/date/infinite), archive state and curated pastel color. Private/expired/archived prayers stay out of Wall; retain them in personal/archive area. Restore clears expired date. No remote publication without a backend.
- Move profile name alongside picture; Prayer partners and Fellowship are frontend empty states with no invented counts or accounts.
- Extend category scroll viewport to screen edges while preserving initial content inset. Keep shared-coordinate create dock; never restore Scaffold/inset BottomAppBar coordinate mismatch.
- Selection icons rotate/scale without vertical bounce.
- Remove right-side post topic pills. Topic remains beneath author and on material.
- Bible-index inspired attached page tabs for Discover/My spaces and Active/Answered/Archive. Shared style also in composer.
- Composer max80% of safe height; inner scroll and pinned safe footer. Topic below input fields, material selector directly above preview, Publish footer. Visibility/duration/stickers/colors between topic and material.
- Remove repeated sample/development guidance from feed, composer and spaces. Keep honest local/backend disclosure in Settings. Exactly3 static community placeholders: Family, Young People, School Friends.
- Keep one add entry in Prayers rather than header plus empty-state duplicate.

Inspiration: physical Bible indexing tabs project past page edges, with readable labels and staggered alignment: https://ascensionpress.com/cdn/shop/files/bible-indexing-tabs-instructions.pdf?v=8697399437684703921 . Translate into stable attached top-corner tabs, not wavy chips.

Verification: migration/round-trip, visibility filtering, stable linking/deduplication, archive/restore/expiry, custom-color ink contrast, phone narrow/large-text and inset dock tests; live composer/order/screenshots; analyze, web/APK build. Public backend and real social connections remain future work, not implied by Publish label.
