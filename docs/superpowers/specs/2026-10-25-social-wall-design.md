# Social wall revamp specification
Date: 2026-10-25. Authorization: auto-plan and auto-execute, no questions or review stops. Read PRODUCT.md and DESIGN.md.

## Outcomes
Wall / Community / Prayers / Profile are the only primary tabs. Wall launches first. Profile contains Today, Journal and Saved. Existing private data and native widget behavior survive.

## Top-area fix
Remove the colored status/navigation strip at its source. Native system bars are transparent over the page canvas; safe insets still protect controls. Web viewport uses viewport-fit=cover and theme-color/CSS backgrounds that match each system theme. No header or tappable content is placed under a notch.

## Wall and local post composer
Implement five material styles (sticky, paper, formal, normal, wall). Render live text and decorations with Flutter; illustrations remain independent transparent assets. A composer exposes title (120), body (1000), topic, material, sticker, foreground/background placement and a live preview. Explicit label: saved on this device, not publicly posted. Validate trimmed nonempty fields, preserve input on failure, disable duplicate save. Persist stable ID, creation time, material, sticker/placement and content under a new versioned key without changing prayer/journal keys. Edit/delete own local posts. Sample posts stay immutable except reversible local prayed/save states. New post appears first; Profile Saved uses actual local saved state. Copy/share copies text with accurate confirmation.

## Feed structure
Compact header, horizontal thematic story tiles that filter posts, compose prompt, topic filter, post author, illustrated material, and meaningful actions. No fabricated online counts, followers, or timestamps. Sample status is visible and new local posts have explicit local audience labels.

## Community
Searchable straight colorful cards with tall arch artwork masks, selected/joined state, All spaces/My spaces toggle, detail with local join/leave and view relevant wall topic. Existing local circle selections remain readable. No wavy edges.

## Prayers and Profile
Reuse working personal list and editor with daily completion independent of answered. Profile embeds Today and journal access; Saved shows the posts actually saved by the user. Settings/backup stay accessible. Focused prayer flow retains duplicate-save/error guards.

## Assets
Retain approved dove, calm boat, loaves/fish, journal. Add consistent lamp, lamb and ark. Biblical associations are in the master plan/provenance. Generated source and prompts stay in project folders. Use meaningful foreground stickers or low-opacity background treatment; maintain legible writing regions.

## Verification
Unit/persistence checks for post CRUD, material validation, stable IDs and saved/prayed persistence. Flutter widget checks for new navigation, composer customization, Community filtering and private data flows. Analyze, tests, web and APK builds. One batched visual review across phone, desktop and both themes; fix defects in one batch, then one confirmation. Independent Impeccable finish review. No native device claim without a connected phone.

## Explicit limits
No remote post publish, auth, live comments, push or moderation backend is added in this UI request. No PNG character articulation or invented online activity. Browser view is not proof of native system-bar behavior.
