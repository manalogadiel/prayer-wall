# Prayer Wall — Master Product, Design, Asset, and Engineering Plan

Version: 1.5 • Updated: 2026-10-25 (Asia/Manila)
Owner: Diel  
Working app name: **Prayer Wall**  
Creative direction: **Soft, graphic, flat, and modern** — Little Flock remains a name/direction candidate only.
Current deliverable: implemented local social wall with the owner-approved monochrome-control/profile refinement. Essential controls are neutral/off-white; colorful content remains. Black notched mobile dock has a raised white create circle. Wall category tiles use one illustration; the header avatar opens the editable device-local Profile, and Settings is available only in Profile. Wall / Community / Prayers / Profile are the primary destinations, Wall launches first, and Today / Journal / Saved live inside Profile. Five material post styles, persistent local composer/CRUD, saved/prayed state and searchable Community are implemented. Owner explicitly authorized automatic planning and execution without questions or approval pauses. Read PRODUCT.md, DESIGN.md and IMPLEMENTATION_STATUS.md before continuing. Chrome proof exists; native Android evidence remains pending and native finish review remains recapture. Refinement browser review is SHIP within the four named Chrome views; `.impeccable/review/refinement-finish-review.md` records no material fixes.

Mascot decision and history: [DOVE_STYLE_EXPLORATION.md](DOVE_STYLE_EXPLORATION.md) records the approved Option A and alternatives. [DOVE_MASCOT_OPTION.md](DOVE_MASCOT_OPTION.md) preserves the original proposal and biblical meaning. These historical proposals do not override the approved master below.

**Approved mascot, confirmed by owner screenshot:** Option A, [clean graphic dove](design-concepts/ollie-a-clean-graphic.png). The owner explicitly clarified that this was the first option they liked. It has an ivory pear-shaped silhouette, lavender teardrop wing with one pale inset, small plum eyes with restrained highlights, peach triangular beak/feet, and three-leaf olive sprig. Use broad 2D shapes and very light shading. This supersedes all sheep-master, sculpted/toy, original-3D-dove, and Option-C recommendations below. Do not mix candidate identities. Keep other concepts as history only. The working mascot name Ollie remains a proposal; the app stays Prayer Wall.

## 1. Start here: instructions for Codex, Claude, and other contributors

This is the canonical specification for continuing the project without the original chat. Read it before generating artwork or changing code. References are included locally; no temporary clipboard paths or running preview are required.

The owner wants an outstanding Christian prayer app: friendly, professional, unique, pleasing to the eye, useful, and reliable. “Best in the world” is a quality ambition, not an evidence-backed marketing claim. Achieve it through excellent daily use, consistency, accessible design, privacy, and dependable prayer/widget behavior.

### 1.1 Priority

1. Follow the owner's latest explicit instructions and the executing environment's applicable rules.
2. Use this file as the canonical roadmap; PRODUCT.md holds current product truth and DESIGN.md holds implemented tokens. The social-wall spec/plan and latest 2026-10-25-monochrome-profile-refinement.md plan under docs/superpowers/, plus UI-SOCIAL-REVAMP-DELIVERY.md, record the current implemented milestone.
3. Read [REFERENCE_ANALYSIS.md](REFERENCE_ANALYSIS.md), [REFERENCE_INDEX.md](REFERENCE_INDEX.md), and all nineteen files in `design-references/` (01–12 initial direction/confirmation and 13–19 current refinement evidence).
4. Use [PLAN.md](PLAN.md) for the original backend roadmap where consistent with this file.
5. [UI-DELIVERY.md](UI-DELIVERY.md) documents the old baseline. Its painted art direction was rejected and is not the design to continue.

This document does not grant credentials, publish permission, access to private services, or authorization to message another AI/chat. A handoff is a portable specification, not permission to send messages externally.

### 1.2 Decision vocabulary

- **LOCKED:** explicit owner requirement; do not change silently.
- **DEFAULT:** selected proposal; implement consistently, and document justified changes.
- **OPEN:** unresolved; do not invent approval.
- **DEFERRED:** outside the current milestone.

| Decision | Status | Requirement |
|---|---|---|
| Flutter/Dart | LOCKED | Keep the app in Flutter. Do not substitute a web-only stack. |
| Android widget | LOCKED | Check off personal prayers directly on the home screen. |
| System theme | LOCKED | Light/dark follows the device by default. |
| Art and UI | LOCKED | Modern, professional, soft, cute; meaningful biblical characters and assets. |
| Borders | LOCKED | No decorative borders on cards or buttons. |
| Rejected style | LOCKED | Replace painted pasture scenery and generic repeated bordered panels. |
| References | LOCKED | Apply the supplied references and approved dove confirmation; create original artwork. |
| Restraint | LOCKED | Artwork supports the app and never overpowers content. |
| Interaction motion | LOCKED | Responsive button feedback and optional subtle meaningful asset motion. |
| Asset approach | LOCKED | Static quality first. Keep static if animation or SVG lowers the quality. |
| Animation handoff | LOCKED | May be passed to **Claude**, not “Glenn.” Preserve portability. |
| Main character | LOCKED | Owner-selected Option A clean graphic dove; use its actual PNG as the reference for every derivative. |
| Main material | LOCKED | Soft graphic 2D forms with light shading, lavender wing; no physical toy render. |
| Essential controls | LOCKED | Monochrome neutral/off-white actions and selections; content/category/community artwork remains colorful. |
| Mobile dock | LOCKED | Black rounded notched dock, raised white central Create post circle, four semantic destinations. |
| Profile | LOCKED | Header avatar opens Profile; approved dove fallback or optional local photo. Editable name/bio/photo first; Today/Journal/Saved below. Settings only here. |
| Typography | DEFAULT | Outfit headings and DM Sans functional text; validate in visual proof. |
| Name | OPEN | Keep Prayer Wall. Little Flock is a creative direction/name candidate, not an approved rename. |
| Backend | DEFAULT | Supabase; Riverpod state; eventual go_router; FCM notifications. |
| iOS widget | DEFERRED | Android is the first native widget target. |

### 1.3 Working protocol

Before starting: inspect Git status, actual code/dependencies, current status file, and references. Preserve existing local changes and user data. Identify the active milestone. Do not reset the checkout or recreate platform files blindly.

At handoff: record completed work with file paths and verification evidence, remaining work, known limitations, changes to decisions, and next executable steps. If a tool is unavailable, state the exact limitation. Never claim an image was generated, a native widget was tested, or a backend was connected unless it actually happened.

## 2. Current baseline: what exists and what does not

Repository: https://github.com/manalogadiel/prayer-wall

The repository containing this document is a local working copy with uncommitted UI changes. Do not assume GitHub already contains this handoff or implementation. No push is implied by creating this plan.

| Area | Current implementation |
|---|---|
| Shell/theme | `lib/app/`; Wall-first black notched mobile dock, raised create circle and neutral desktop rail; Outfit/DM Sans with OFL licenses |
| State/storage | `lib/core/store.dart`, `wall_post.dart`; Riverpod and serialized SharedPreferences writes |
| Wall | `lib/features/wall/`; five materials, local composer/CRUD and saved/prayed persistence |
| Screens | `lib/features/home.dart`, `community.dart`; Profile starts with editable local name/bio/photo, then Today/Journal/Saved; Settings only in Profile |
| Personal prayers/journal | Stable-ID CRUD, daily completion independent of answered; journal migration and failure protection |
| Android | MainActivity/PrayerWidget, MethodChannel, native RemoteViews; transparent bars/edge-to-edge source |
| Artwork | Approved dove plus boat, bread/fish, journal, lamp, lamb and ark; original prompt provenance |
| Tests/builds | 16 tests pass after final correction; analysis zero issues; final web release passed (115.4 seconds). Four-view Chrome review SHIP; native acceptance remains recapture. Current APK attempt failed on Google dependency download; historical APK success predates this refinement. |

Earlier Chrome proof lives in `design/proofs/social-revamp/`. Current refinement captures are retained in `.impeccable/review/refinement-{mobile-dark,mobile-light,profile-dark,desktop-light}.png` with copies in `design/proofs/monochrome-refinement/`; independent browser review is SHIP within these four views, recorded in `.impeccable/review/refinement-finish-review.md`. Native acceptance remains separate. Independent `.impeccable/review/finish-review.md` remains **recapture** because no Android capture exists; the Chrome/source supplement is separately labeled. Native system bars/insets, keyboard and launcher widget behavior require actual device evidence. Historical six/ten-test results are superseded by current status.

Not implemented: real auth, Supabase shared wall/circles, comments, moderation, cloud sync, push, release signing/store release or iOS widget. Do not infer public posting from the local composer.

Read `pubspec.yaml` and the lockfile before edits. Current dependencies include flutter_riverpod, shared_preferences and official Flutter image_picker 1.2.4; planned packages are not installed merely because this document names them.

## 3. Product behavior and principles

### 3.1 Core jobs

1. Keep a personal prayer list and remember it during ordinary days.
2. Mark a prayer as prayed today from the app or Android widget.
3. Pray with other people and find a supportive circle.
4. Write private reflections and remember answered prayers.

Support gratitude and distress with equal care. Cuteness must not trivialize serious prayer content.

### 3.2 Non-negotiable semantics

- **Prayed today** is a dated action. **Answered** is a separate, explicit user assessment.
- No automatic answered status from checking a box.
- No spiritual scores, competitive leaderboards, guilt streaks, disappointed mascots, or rewards suggesting spiritual superiority.
- Personal prayers and journal entries are private by default. Public sharing is a distinct action with a visible audience.
- Guests may browse and pray. Real public posting/commenting requires an account and circle authorization.
- Local prayer/widget use must not require signup.
- Do not upload local private content automatically when an account is created.
- Sample interactions remain labeled sample until connected to real services.
- Never promise a particular divine outcome or a prayer being answered because someone completed an app action.

### 3.3 Scope

Current local social wall UI revamp is implemented; the next acceptance work is Android device verification. The local prayer experience and Android widget form the first usable beta. A public community release requires real auth, security, moderation, privacy, deletion, and operational readiness.

Defer unsolicited expansion into AI spiritual counseling, a character marketplace, subscriptions, full Bible-study software, voice features, and competitive gamification. Keep language localization-ready; English is current, Filipino/Tagalog remains open.

## 4. Reference interpretation and art direction

The references are inspiration, not app assets or exact designs to copy. Their typography cannot be identified definitively from screenshots; proposed fonts and palette values are original choices.

| Reference | Adopt | Do not reproduce |
|---|---|---|
| 01 Lavender planner | Strong type, colored hierarchy, purposeful asymmetry, occasional asset overlap, dark navigation capsule | Arbitrary rings, outlined date controls, crowded decorative objects |
| 02 Moimoi | Expressive simple faces, confident silhouettes, cropped group compositions | Exact mascots/logo or meaningless speech bubbles |
| 03 Lime mascot | Few recognizable facial features, identity through silhouette | Neon saturation across every page, low-contrast fields |
| 04 Classroom | Belonging, grouped figures, compact functional composition | Tilted/overlapping readable prayers or a second unrelated art family |
| 05 Toy characters | Soft matte volume, large heads, short limbs, consistent lighting | Toy marketplace, costume overload, weak white-on-pastel text |
| 06 Health | Functional spot illustrations, useful color coding, clean rows | Fake prayer statistics, medical-style scores, unrelated comic art |
| 07 Sheep vector | Scalloped wool silhouette, simple eyes/mouth, drooping ears, small-size clarity | Exact commercial vector tracing, copied proportions/colors, browser chrome |

### 4.1 New sheep reference analysis

The principal sheep is flat vector artwork with a scalloped white wool mass, cream lower shadow, taupe face/legs, purple-dark hooves and ears, peach inner ears, oval eyes with small highlights, and a compact curved mouth. A forehead tuft overlaps the face. The quiet blue-green background makes the silhouette easy to read. Minimal internal marks carry the expression.

The screenshot also contains two smaller related sheep thumbnails with different treatments. They are not permission to mix all three styles. The browser/search controls, site branding, and text are not app UI inspiration. The screenshot visibly identifies a licensable illustration; use its design principles, not the supplied art as a shipped asset.

### 4.2 Unified style: approved clean graphic dove

Use `assets/illustrations/characters/dove_master_v002.png`, copied from owner-selected Option A in `docs/design-concepts/ollie-a-clean-graphic.png`. Owner confirmation screenshot is `docs/design-references/08-approved-dove-confirmation.png`. The first original 3D concept and B/C alternatives are historical only.

The language is soft graphic 2D: broad rounded silhouettes, a few layered filled regions, very restrained color shading, no painterly textures, physical toy material, realistic feather detail, studio glare, or scenery. Objects use the same simplicity and gentle perspective. Do not add faces to every object. The fish may retain simple eyes appropriate to animals.

### 4.3 Master character specification

- Ivory pear-shaped body, head flowing into body, compact perched pose, short three-lobe tail.
- Lavender teardrop wing with one pale inset, no individually modeled feathers.
- Small plum oval eyes with one restrained highlight; peach triangular beak and feet.
- Small sage olive sprig with three broad leaves. Its visual connection to Genesis 8:11 is a brand interpretation of the fresh olive leaf.
- Keep this identity and palette in every future pose; use the actual approved master as a generation reference.
- Expressions remain quiet and welcoming; no disappointed mascot or exaggerated celebration for sensitive content.
- Static master is production fallback. Do not distort the raster to force blinking. Future vector articulation must retain identity and be reviewed at final size.
- Sheep remains an optional supporting biblical asset, not a second competing master.

## 5. Biblical asset library

Every asset needs an intended use. A future library of approximately 45–60 reusable assets does not mean generating all of them before validating the style, nor placing many illustrations on one screen.

### 5.1 Story compositions

| Asset ID | Biblical source | Visual interpretation | Use |
|---|---|---|---|
| `story_lost_sheep` | Luke 15:4–7, parable | Lamb, small curved path, optional staff | Welcome/community invitation |
| `story_calm_boat` | Mark 4:35–41 | Rounded fishing boat and two low waves | Peace/reflection |
| `story_loaves_fish` | John 6:9–13 | Five barley loaves and two fish in a basket | Gratitude/provision/sharing |
| `story_noah_dove` | Genesis 8:11 | Dove with one olive leaf; ark only in expanded scene | Hope |
| `story_samaritan_care` | Luke 10:30–37, parable | Oil vessel and rolled bandage | Care/support |
| `story_ruth_barley` | Ruth 2:1–17 | Barley bundle and gathering basket | Provision/family support |
| `story_memorial_stones` | Joshua 4:1–7 | Twelve grouped memorial stones | Remembering answered prayers |
| `story_welcome_home` | Luke 15:20–24, parable | Folded robe; optional symbolic doorway | Reconciliation reflection |

Doorway is an artistic symbol, not a claimed detail of those verses. Memorial stones should not look like a generic balancing spa tower. Do not use the lost sheep/prodigal son to label a returning user as sinful or lost. A calm boat is a reflection motif, not a promise that hardship will instantly end.

### 5.2 Production priorities

**P0: implemented set** — approved dove/olive sprig; calm boat; bread/fish basket; open journal; guiding lamp; matching lamb; ark; simplified original dove app mark; essential navigation/actions. Seven original PNGs have embedded prompt metadata (zero missing); provenance is in design/asset-manifest.json. Additional dove poses and memorial stones may follow only where useful. The planned larger library is incremental, not a requirement to fill each screen.

**P1: everyday library**

- Lamb poses: listening, resting, reading, journaling, walking with another sheep, welcoming a small sheep, carrying an olive sprig, holding a heart, watching a sprout.
- Group compositions: two sheep and small flock.
- Supporting characters: sparrow, hen/chicks, fish pair; each only in a meaningful context.
- Objects: oil lamp, open Bible, closed Bible/ribbon, scroll, olive branch, seed/sprout, bread, wheat/barley, water jar, well, cup, journal, staff, stepping stones, tree by water, doorway, house on rock, grapevine.
- Small scenes: still waters, lamp/path, sheep gathered around a Bible, daily bread, calm boat, rooted tree, growing seed, welcoming doorway, journal/memorial stones, resting beneath vine. Limit each scene to 3–5 significant elements.

**P2: optional and seasonal** — donkey, deer, dignified lion, harp, sandals, tent, anchor; Christmas manger/star; Palm Sunday palm/donkey; Easter empty tomb/stone/dawn; Pentecost flame with explicit context.

Human biblical figures or depictions of Jesus are OPEN decisions. The initial object/animal system does not require resolving them. Do not introduce a depiction policy silently.

### 5.3 Static asset workflow

1. Inspect references and establish original character master sheet: silhouette, palette, front/three-quarter views, expression grid, proportions.
2. Produce a small proof set, not the entire library.
3. Reuse approved master files as actual generation references for every variation.
4. Generate one production asset/composition per image. Request transparent backgrounds and specified props only.
5. Reject incorrect limbs, mismatched face/light/material, extra objects, text, watermarks, or inconsistent scale.
6. Review in actual Flutter layouts and at widget size on light/dark surfaces.
7. Export optimized PNG/WebP variants according to renderer support; keep source masters separately.
8. Record provenance, prompt, references, version, intended screen, dimensions, and approval status.

Prompt template:

> Original soft graphic 2D illustration matching the approved Option A dove reference. Preserve its broad rounded shapes, sparse plum facial features, ivory/lavender/peach/sage palette and very restrained shading. [POSE OR SIGNIFICANT OBJECT]. Use the supplied master as an actual reference. Transparent background, clean silhouette. No physical 3D toy, realistic texture, painted scenery, words, glare, or unrequested accessories.

Keep shared object materials/light; do not add a face to every object. Use original vector geometry for crisp icons instead of generated raster icons.

### 5.4 Files and manifest

```text
assets/illustrations/characters/
assets/illustrations/objects/
assets/illustrations/scenes/
assets/icons/
assets/fonts/
design/masters/
design/proofs/
design/motion/
design/asset-manifest.json
```

Manifest fields: `id`, `version`, `status` (proposed/generated/reviewed/approved), source path, exported paths, master reference, generator/tool, prompt file, license/provenance, target logical size, source pixels, role, decorative flag/semantic label, dark-mode review, animation eligibility, static fallback, reviewer/approval evidence.

Use stable names such as `lamb_welcome_v001.png` and `lamb_welcome_static.svg`; do not overwrite approved masters destructively. An agent's preferred output is not owner approval. No asset may depend on temporary clipboard paths.

## 6. Optional asset animation and Claude handoff

### 6.1 Static-first rule

Every asset is designed, reviewed, and usable as a static image first. Animation is a separate optional layer. It must preserve the approved face, silhouette, material, color, and legibility. The app must be fully functional and attractive with all asset motion disabled.

The owner may pass motion work to **Claude**. This plan does not ask Codex to contact Claude automatically. Provide editable sources and a written motion specification so either agent can continue without redesigning the character.

### 6.2 Meaningful motion candidates

| Asset | Optional action | Trigger and limit | Static fallback |
|---|---|---|---|
| Sheep | Short natural blink | One blink on entry or occasional user-triggered interaction; no attention-seeking perpetual loop | Open-eye master |
| Listening sheep | Small ear/head tilt | Opening a private prayer focus, once | Attentive pose |
| Completion sheep | Slight nod/expression change | Finishing private checklist, once | Gently pleased pose |
| Dove | Small head turn or single restrained wing settle | Opening a peace reflection, once | Perched dove |
| Boat | Tiny settle/tilt, no traveling background | Optional reflection entry, once; omit if distracting | Calm boat |
| Lamp | Subtle flame shape change | Optional focused reflection, brief; no flashing brightness | Static flame |
| Journal | Single page transition | Opening a reflection, once | Open book |
| Sprout | Small leaf unfold | Explicit first-prayer milestone, once | Open sprout |
| Memorial stones | None | Their stillness suits remembrance | Static group |
| Bread/fish | None | Decorative wobbling has no useful meaning here | Static basket |

Sheep blink starting timing: close 60–80 ms, closed 30–50 ms, reopen 80–100 ms; keep face/head still. Use an alternate closed-eye path or controlled eye-group transform rather than flattening the entire head. These are proposed values to review, not mandatory biological timing.

Do not animate every visible character simultaneously. No constant bouncing, waving, glowing, exaggerated squashing, confetti, sad reactions to missed prayer, or motion responding to the emotional content of public requests.

### 6.3 SVG/runtime boundary

- SVG is useful for clean, layered vector art. It is not inherently an animation runtime.
- Browser CSS/SMIL animations inside SVG are not automatically supported by Flutter SVG renderers. Verify the selected library and API before implementation.
- A static SVG can be drawn with a supported Flutter SVG renderer; a blink can use Flutter state/animation swapping eye layers or a CustomPainter implementation.
- For complex articulation, consider a separately authored Rive asset only after checking need, runtime support, licensing, and performance. Do not introduce Rive/Lottie merely for one blink.
- Raster sculpted artwork cannot become a clean rig by automatic vector tracing alone. Prefer a consistent static raster over a poor flat conversion.
- If an animated SVG is supplied for web, also supply a Flutter-compatible strategy and static fallback. Do not silently embed a WebView just to animate a mascot.
- Android RemoteViews widgets keep a static character and immediate check state; full Flutter/SVG animation is not a widget requirement.

### 6.4 Editable layer contract

For a vector derivative use a stable `viewBox` and named groups: `body`, `legs_back`, `legs_front`, `head`, `wool_front`, `ear_left`, `ear_right`, `eye_left_open`, `eye_right_open`, `eyes_closed`, `mouth`, `accessory`, `shadow` as needed. Document pivot coordinates and stacking order. No embedded scripts, external assets/fonts, or raster tracing artifacts. Remove unnecessary clipping/filter complexity. Icons remain a separate lightweight vector set.

Each motion handoff includes approved static reference, editable source, layer/pivot map, trigger, duration, easing, limits, reduced-motion state, interruption behavior, target runtime, export instructions, license/provenance, preview recording if produced, and acceptance checklist. See [MOTION_HANDOFF.md](MOTION_HANDOFF.md).

## 7. UI tokens, typography, and restraint

### 7.1 Implemented palette

| Token | Light | Dark |
|---|---|---|
| Canvas | #F7F8F5 | #262626 |
| Surface | #FFFFFF | #303034 |
| Main text | #191B24 | #F4F3F8 |
| Secondary text | #535661 | #B8BCC9 |
| Theme primary / selected chips / focus | #25262B | #F0EFEA |
| Essential ActionButton | #FFFEFA → #E9E9E3 | #FFFEFA → #E9E9E3 |
| Essential action text | #202126 | #202126 |
| Mobile dock / create | #0D0E12 / #F9F9F3 | #0D0E12 / #F9F9F3 |
| Lilac | #D5CBFF | #39314E |
| Reflection blue | #D5E8FB | #263B4A |
| Gratitude butter | #F7DEA0 | #453B28 |
| Community mint | #D9EBCB | #2D3E31 |
| Peach accent | #F5BDB0 | #51352F |

DESIGN.md frontmatter is the normative extracted token record, including all post material and dark equivalents. Validate actual combinations; targeted checks are not a complete accessibility audit. The social wall intentionally uses richer topic/material color; keep essential actions and selection controls monochrome in both themes.

### 7.2 Type and geometry

- Outfit headings and DM Sans body/controls are bundled with OFL licenses.
- Theme headlines 34/30/26 and title 22, Outfit 600 at 1.12 line height; body 16/14 at 1.5 and small 12 at 1.4. Post titles 25 at 1.15 and body 16 at 1.6. Compact 11px category/metadata are observed exceptions for future device readability review, not a general type standard.
- Sentence case, short functional text, natural wrapping. No handwritten UI labels, ornamental all-caps eyebrows, fake statistics, or repeated generic slogans.
- Spacing scale: 4/8/12/16/24/32; phone gutter 20, or 16 on narrow screens.
- Buttons radius ~16; content surfaces 20–24; chips are pill-shaped; mobile navigation is a rounded notched dock.
- No decorative strokes on cards/buttons. Use fill, space, and selective soft elevation.
- Icons: consistent 24-unit grid, rounded strokes around 1.8–2 units, optical sizing, filled selected variant.
- Touch targets at least 48 logical pixels; meaningful selected/disabled/focus states.
- Keyboard focus must remain clearly visible; the no-border rule is not permission to remove accessibility feedback.

### 7.3 Asset placement budget

- Today: one lead asset around 112–160 logical pixels tall; primary action and initial prayer rows should fit on a typical phone.
- Wall: expressive selectable material/sticker art supports readable live text; author and actions remain outside the material. Journal becomes writing-first when populated.
- Current Wall category tiles: 92×100 logical-pixel art fields with one 82px illustration. Empty states and widget art remain role-specific; do not impose this tile size on every category surface.
- Do not impose the retired dashboard art budget on the expressive social feed. Use meaningful topic/sticker art, coherent scale and a clear writing region.
- Large text wins: reduce/remove decoration before reducing font size or clipping content.
- Asset overlap never covers text, navigation, or hit targets.

## 8. Information architecture and screen contracts

### 8.1 Navigation

LOCKED current hierarchy: **Wall / Community / Prayers / Profile**. Wall launches first. Profile contains **Today / Journal / Saved**. No separate Discover primary tab. Mobile uses a shared-coordinate Stack with a black rounded 64px clipped dock and raised off-white Create post circle; the notch and button use the same local center. White selected icons/dot and gray inactive icons retain accessible semantic names/tooltips. At 1000 logical pixels use a 220px desktop rail with visible labels and neutral selection. Settings is available only from Profile. Current shell uses local page state; proposed future routes are not implemented deep links.

### 8.2 Wall and local composer

Compact header with profile avatar, explicit Prayer categories heading and single-art horizontal topic tiles, compose prompt, topic filters, then author/material/action feed. Preserve local/sample audience labels. Story tiles and Community topic links filter Wall. Wall width is capped at 680 logical pixels on desktop.

Five materials: Sticky note, Paper, Formal, Normal, Wall. Author and actions remain outside the material. Live composer has title (120), body (1000), topic, material, optional sticker, foreground/background placement and preview. Validate trimmed nonempty content, retain input on failure and guard repeated save. Local stable-ID posts can be edited/deleted and appear before sample content. Persist local posts under `wall_posts_v1` and saved/prayed state under `wall_state_v1`; do not alter prayer/journal keys. Saved in Profile reads actual local state. Copy/share copies text with truthful confirmation. No public publish or account requirement is simulated.

Future public posting requires backend auth/authorization, privacy and moderation; do not import those future fields into a fake live composer.

### 8.3 Community

Searchable straight colorful cards with tall arch artwork windows; no wavy edges. Discover / My spaces filters, detail sheet, explicit local add/leave state and View prayers topic navigation are implemented. The local selection does not enroll a person in a live community. At available width 700px use two columns with 16px gaps; large text removes side art. Real public/private membership and invitation validation remain backend work.

### 8.4 Prayers

Active/Answered views; add/edit validated title, daily check/undo, explicit answered/reactivate, delete/undo and widget inclusion. Preserve IDs when editing. List works offline and failed saves remain recoverable. Optional notes and ordering remain incremental.

### 8.5 Profile: editable identity, Today / Journal / Saved

Profile begins with avatar, editable name (60 characters), optional bio (160), optional photo and Edit profile. The header avatar opens Profile and uses the approved dove when no photo is set. Photo selection uses official Flutter image_picker 1.2.4, image sizing/compression and a 1 MB byte limit; no upload. Name/bio/photo persist through the existing queued writes in `profile_v1`; failed writes keep editor input. This is device-local identity, not an authenticated public account.

Today retains focused first-unchecked prayer, checklist and calm empty/all-done behavior. Journal supports private local CRUD, stable-ID migration without invented historical dates and an open-book empty state. Saved displays the posts actually selected by the user, with reversible saved state. Profile does not fabricate follower counts, accounts or online activity.

### 8.6 Settings and all screen states

Settings is available only in Profile. System/Light/Dark override and JSON clipboard backup are implemented; schemaVersion 4 export contains private prayers/journal, local posts/state and device-local profile/photo. Keep exported copies private. Native widget follows Android system appearance. No fake passwords/signup, import/restore or cloud backup. Loading, empty, failed load/mutation, cancel, success and undo states must preserve recoverable input. SafeArea protects controls; the status-bar overlay requests the actual canvas, while the navigation bar stays transparent and Android edge-to-edge remains enabled. Web CSS, launch background, metadata and browser bridge track the same canvas. Verify this on Android before declaring the top-strip bug visually closed.

## 9. Interaction motion and accessibility

| Interaction | Behavior | Starting timing |
|---|---|---|
| Button touch | Scale 1→.97, restrained return spring | 90 ms down, 160–200 ms return |
| Check prayer | Immediate state, small check/fill, optional light haptic | 140–180 ms |
| Complete private checklist | One gentle pose change | 250–350 ms |
| Navigation | White selected mobile icon/dot; neutral rail selection; short icon transition | 180–220 ms |
| Composer | Controlled sheet entry with keyboard handling | 220–260 ms |
| Filter | Filled selection, direct list update | 120–160 ms |
| Error/undo | Clear functional feedback, no playful reaction | Immediate |

Honor platform reduced motion via current Flutter APIs. Suppress scale, travel, blink, and decorative reactions; retain final states. No forced sound, shake, flashing, parallax, ambient animation loops, or animation blocking a second tap. Keyboard actions can be immediate.

Accessibility: 4.5:1 normal text, 3:1 large text/meaningful controls; non-color state cues; proper labels/roles/states; logical focus; readable large text; TalkBack/keyboard verification. Decorative art excluded from semantics; meaningful art has concise alternative text. Do not claim full compliance from screenshots alone.

## 10. Flutter architecture and persistence contracts

### 10.1 Target structure

```text
lib/app/                 app, router, themes, environment
lib/core/design/         color, spacing, type, motion tokens
lib/core/widgets/        controls, icon/asset wrappers, state views
lib/core/storage/        local repositories and migrations
lib/features/today/
lib/features/personal_prayers/  domain, data, application, presentation
lib/features/wall/
lib/features/circles/
lib/features/journal/
lib/features/auth/
lib/features/settings/
lib/features/moderation/
lib/features/notifications/
lib/platform/            native widget bridge
android/app/src/main/    native data store, receiver, resources
supabase/                migrations/functions/tests when implemented
test/                    domain, persistence, widget tests
integration_test/        platform flows
```

Retain Riverpod. Separate domain/repository logic from presentation. Refactor incrementally; do not change storage merely for stylistic purity. Inject clock/storage for reliable tests. Verify package versions/APIs rather than assuming a named package is already installed.

### 10.2 Personal prayer model

Current JSON: `id`, `title`, `date`, `answered`, `pinned`. `date` is last completed local `YYYY-MM-DD`, not UTC time. Today is computed from date comparison rather than depending on a reset timer.

Future schema proposal: ID, title, createdAt, updatedAt, lastPrayedLocalDate, answeredAt nullable, optional answeredNote, includeInWidget, sortOrder, schemaVersion. Not yet implemented. Preserve unknown historical timestamps as unknown; don't fabricate precise times.

- Use device timezone at interaction time; recompute on resume/date/timezone change.
- Existing date strings retain literal calendar meaning; do not silently rewrite history when timezone changes.
- Stable IDs across Flutter/native actions; never identify by row position.
- Serialize overlapping mutations. Check rapid additions and native/app concurrent updates.
- Reactivation from Answered is explicit. “Prayed” and “Answered” remain independent.

### 10.3 Storage migration

Current Android: SharedPreferences file `prayer_widget`, JSON key `prayers`, channel `prayer_wall/widget`; methods `load`, `add`, `toggle`, `pin`, `answer`, `delete`, `pinWidget`. Inspect exact payloads in source. Current web: SharedPreferences key `prayers`; additional `journal`, `joined`, `theme`.

Create fixture-based migrations before changing formats. Do not wipe user data to make the redesign work. Current local content is not app-encrypted or cloud-backed; Android backup is disabled. Be clear that uninstall may lose local data. Export/backup/cloud policy must be defined for beta; private cloud sync is an OPEN decision, not automatic permission to upload.

## 11. Android widget specification

- Real native RemoteViews widget; Flutter preview is a simulation, not proof of native behavior.
- Up to three included active prayers, stable ordering, clear empty state; header opens app. Future deep-link-to-My-prayers behavior must be implemented before claimed.
- Tap toggles the stable prayer ID for today without opening Flutter; second tap undoes it.
- Shared native store is authoritative on Android. Refresh all placed widget instances after changes and reload Flutter state on resume.
- Avoid stale Flutter snapshots overwriting native actions.
- Use explicit immutable PendingIntents and app-private storage. Validate receiver/export configuration against current Android requirements.
- Pin request only on supported launchers; manual widget-picker guidance otherwise. Cancellation is not successful installation.
- Date comparison guarantees correct evaluation on interaction; Android may defer passive updates. Do not promise exact midnight refresh.
- Test long titles, large fonts, resizing, empty/all-checked, deleted/answered/unpinned items, theme changes, multiple instances, reboot, app process closed, next-day/timezone boundaries.
- Prioritize rows over artwork; static 40–56-pixel character spot instead of a tall landscape header.
- Widget prayer titles are visible on the home screen. Explain this. A generic-title privacy mode is a possible later enhancement, not current functionality.
- Android widget does not need blinking or Flutter-style springs. Immediate reliable check feedback is sufficient.
- Record actual device/OS/launcher evidence. Build success alone does not satisfy the device acceptance gate.

## 12. Backend and public-community requirements

### 12.1 Planned services and schema

Supabase Auth/Postgres/RLS/Realtime/Storage/Edge Functions; FCM push. Verify current APIs, costs, quotas, and policies when implementing. Old free-tier claims or anti-pause workarounds are not guaranteed requirements.

Core entities from original plan: profiles, circles, circle_members, posts, prayers (public acknowledgments), comments, saved_posts, journal_entries, reports, blocks, device_tokens. Personal prayer tasks are a separate domain; if synchronized, create owner-private personal_prayers rather than conflating them with public posts.

Use foreign keys, pagination indexes, unique public acknowledgment per user/post, server-owned counts, and field-specific permissions. Authors must not set aggregate counts or bypass moderation by writing arbitrary status values.

### 12.2 Security and privacy

- No service-role keys, FCM credentials, signing secrets, or private tokens in client code, assets, docs, or logs.
- Database enforces ownership/circle access. Hiding a UI control is not security.
- Anonymous feed projection must remove identifying fields for unauthorized readers, including indirect avatar/URL/query leaks.
- Do not assume a view is safe: privileged views can bypass RLS. Design/test secure queries, RPCs, or views with least privilege.
- Guests may browse/pray; non-guests post/comment. Account upgrade must preserve data through verified linking, not unproven assumptions.
- Private journals/prayers/saves/tokens require owner-only access. Privacy wording must accurately describe operator access and storage.
- Account deletion, data handling, retention policy, and cloud opt-in must be explicit before release.

### 12.3 Moderation and notifications

Before public user-generated content: reports, blocking, moderator queue, rate limits, guidelines, deletion, and responsible operational coverage. Original “three reports auto-hide” is a proposal requiring abuse/brigading review, not an unquestionable rule.

Do not log prayer or journal bodies in routine analytics. Notifications are opt-in, grouped appropriately, and avoid sensitive lock-screen text by default. Reminders have user-selected timing and gentle copy. Any crisis-resource functionality requires its own verified resource/response policy; adding a keyword list does not complete it.

## 13. Copy, scripture, and identity

Use functional labels: Add prayer, Prayed today, Mark answered, Write a reflection, Join circle. Poetic copy is occasional, not filler repeated on each screen. No invented activity counts, testimonials, accounts, or names.

Verify scripture text, citation, translation, and distribution rights before bundling; do not assume every translation is free or that one licensing statement covers all territories. Keep design interpretations separate from quotations. Do not add doctrinal/AI-generated spiritual teaching without explicit product scope.

Name candidates: Little Flock, Still Waters, Selah, Olive & Amen, Manna. No trademark/domain checks completed. Keep Prayer Wall and existing package identifiers until a decision.

## 14. Quality and performance targets

These are targets, not measured claims:

- Smooth 60 Hz interaction on representative mid-range Android hardware; investigate sustained frame times above approximately 16.7 ms.
- Local prayers/widget operate without a network connection.
- Load only screen-required art; avoid decoding large masters or the whole library at startup.
- Aim for small spot exports around 50–200 KB, larger screen art under ~400 KB where feasible; measure and preserve visual quality/alpha.
- Do not sacrifice reliable state or readability for decorative motion.
- Test 320/390/430 logical-pixel phones, tablet/desktop, long content, large type, both themes, reduced motion, screen readers, and keyboard.
- Add dependencies only when justified and compatible. Static SVG, animated SVG, Rive, Lottie, and native widget rendering are different capabilities.

## 15. Milestones and acceptance gates

### M0 — Baseline and preservation

Inspect actual checkout, available tools/devices, storage, tests, dependencies. Record baseline evidence and migration fixtures. Preserve user data and uncommitted work.

### M1 — Static/browser proof (completed; native proof pending)

Implemented social-wall browser proof covers Wall phone/desktop, Community phone/dark desktop, Profile and composer. See historical design/proofs/social-revamp/ and current design/proofs/monochrome-refinement/. Current four-view Chrome refinement review is SHIP in .impeccable/review/refinement-finish-review.md; final web release and 16 tests/analysis passed. Native Android screenshot proof remains pending; independent review requests recapture. The owner-approved Option A dove remains binding.

**Gate for this implementation:** the owner authorized proceeding with the full redesign using best judgment and then selected Option A by screenshot. Review actual screenshots internally and record limitations; no additional visual-proof stop is required in this run.

### M2 — Flutter design system and local screens

Implement approved tokens/components/navigation/screens. Replace rejected artwork. Preserve local IDs/data/preferences. Keep disconnected community features visibly sample. Gate: usable primary actions, tested persistence, no narrow-screen overflow, no decorative card/button borders.

### M3 — Native widget redesign

Apply style in Android resources and verify shared state/lifecycle, sizing, pin/undo, and long titles on available devices. Gate: actual device evidence; if unavailable, explicitly leave that verification pending.

### M4 — Private beta

Finish prayer edit, journal CRUD/model migration, useful failure/offline states, export/backup decisions. Gate: reliable end-to-end personal prayer experience without network.

### M5 — Real community

Implement Supabase schema/RLS/tests, account/guest linking, wall/circles/comments, pagination/realtime. Gate: tested privacy/ownership/anonymous projection and accurate counts.

### M6 — Moderation and notifications

Complete report/block/moderation/deletion/guidance/preferences/push. Gate: operationally supportable public content and tested account/data flows.

### M7 — Release readiness

Performance/accessibility/security review, production signing, platform metadata, icons, licensing, privacy, deployment checks. Verify iOS on macOS if targeted; Flutter source alone is not proof. Release actions require applicable user authorization.

### Optional motion milestone — after static approval

Codex or Claude implements one sheep blink proof using the motion handoff, compares it to static at actual size, and verifies reduced motion and Flutter support. Expand only if it improves the app. Static assets remain valid production output.

## 16. Acceptance tests and evidence

| Area | Required coverage |
|---|---|
| Personal prayers | Add/edit/delete/check/undo; answered independent; stable IDs; rapid mutations |
| Storage | Reload/restart, migration fixtures, failed writes, no silent data loss |
| Dates | Local day boundary, timezone changes, native/app agreement |
| Layout | 320/390/430, tablet/desktop, large text, long titles, light/dark |
| Motion | Reduced motion, repeat taps, interrupted animation, no input blocking, static fallback |
| Assets | Consistent master identity, clean alpha, final-size clarity, no borrowed commercial art |
| Native widget | App closed/background/foreground, multiple instances, pin cancellation, resizing/reboot |
| Community | Real access rules, anonymous leaks, guest restrictions, private circle denial |
| Accessibility | Semantics, focus, contrast, targets, TalkBack/keyboard |
| Builds | Analyze/tests/web/Android; iOS only with available tooling |

Typical commands, after checking project/toolchain:

```sh
flutter pub get
flutter analyze
flutter test
flutter build web --release
flutter build apk --debug
```

Write meaningful behavior/failure tests. Do not treat a successful build as device testing, production signing, or proof of all UX states. Run appropriate checks after relevant changes, not endless unrelated tests.

## 17. Cross-agent handoff and decision discipline

Codex and Claude must use the same master references, tokens, filenames, storage contracts, and milestone statuses. Record changes rather than quietly starting a new art direction. Any AI should be able to continue from local files without this chat.

Update `IMPLEMENTATION_STATUS.md` after substantial work with:

```markdown
# Implementation status
Updated:
Agent/tool:
Plan version:
Checkout/branch/commit:
Active milestone:

## Completed with evidence
- Requirement/section, files, check results, screenshots.

## In progress
- Remaining concrete work.

## Blockers/capability limits
- Exact failure, attempts, unavailable tools/devices, next useful independent step.

## Decisions and approvals
- Default changed and why; actual owner approval evidence where needed.

## Next executable steps
1. ...

## Local changes/running services
- ...
```

If generation is unavailable, prepare prompts/manifest/source instructions; never call emoji or unrelated placeholders finished art. If animation is poor or unsupported, retain approved static assets and report the limitation. If auth/backend/device tools are unavailable, keep the missing part explicit and finish independent reviewable work.

New-agent prompt:

> Read docs/MASTER_PLAN.md, docs/IMPLEMENTATION_STATUS.md, docs/REFERENCE_INDEX.md, and the reference images and approved dove confirmation. Inspect the working tree. Identify the active milestone and differences between docs and code. Continue the authorized milestone while preserving existing changes and data. Keep the approved character/style system, meaningful restrained assets, borderless controls, and static fallback. Do not claim unverified behavior. Update the status with evidence and next steps.

## 18. Open decisions

Final app/mascot name; human/Jesus depiction policy; private cloud backup/encryption/export strategy; launch moderators; denominational/content positioning; Filipino/Tagalog support; reminder schedule; iOS widget timing; scripture translation rights. Resolve only what blocks the active milestone, not all questions at once.

## 19. Sources and document history

Scripture sources verified during planning:

- https://www.biblegateway.com/passage/?search=Luke+15%3A4-7&version=KJV
- https://www.biblegateway.com/passage/?search=Mark+4%3A35-41&version=KJV
- https://www.biblegateway.com/passage/?search=John+6%3A9-13&version=KJV
- https://www.biblegateway.com/passage/?search=Genesis+8%3A11&version=KJV
- https://bible.usccb.org/bible/luke/10
- https://www.biblegateway.com/passage/?search=Ruth+2%3A1-17&version=KJV
- https://www.biblegateway.com/passage/?search=Joshua+4%3A1-7&version=NKJV
- https://www.biblegateway.com/passage/?search=Luke+15%3A20-24&version=KJV

Android reference: https://developer.android.com/reference/android/appwidget/AppWidgetManager — verify current official APIs at implementation time.

Version 1.1, 2026-10-25: first successfully saved canonical master after the earlier write was interrupted. Consolidates the full product/design/asset/engineering discussion; includes seventh sheep reference, static-first motion policy, and **Claude** animation handoff. No revamp implementation or new generated production assets are claimed by this planning deliverable.

Version 1.3, 2026-10-25: owner confirmed Option A clean graphic dove by screenshot. Replaced the sheep master and contradictory material defaults; retained history separately. Full local Flutter redesign authorized. See IMPLEMENTATION_STATUS.md for current build/test evidence.

Historical version 1.4, 2026-10-25 (verification applies only to that earlier revision): social wall implementation replaces Today-first dashboard. Added five local post materials/composer/CRUD, saved/prayed persistence, Community selection, Profile nesting, lamp/lamb/ark and native/web top-area source changes. Canonical visual tokens captured in DESIGN.md and .impeccable/design.json. Fourteen tests pass; analysis and web/APK builds succeed. Chrome proof is distinct from pending Android acceptance; independent finish review remains recapture.


Version 1.5, 2026-10-25: monochrome essential controls, black notched dock/raised create circle, single-art Prayer categories and editable local Profile implemented. Settings is restricted to Profile. Dark canvas is neutral charcoal across owned layers; source overlays request actual canvas. References 13–18 retained. Sixteen tests passed again and analysis reported zero issues after final correction; final web release passed (115.4 seconds). Independent browser review is SHIP within four Chrome views, no material fixes. Current Android APK attempt failed downloading androidx.collection:collection-ktx:1.4.2 from Google because host/network was unavailable; no current APK or native visual acceptance is claimed. External phone frame remains unverified: Computer Use stopped when Chrome URL could not be verified.


Latest device delivery (2026-10-25): current debug APK build passed (58.6s) and ADB replacement install succeeded on Samsung SM-A326B, user 0. Prior dependency-download failure is historical. Native visual/widget acceptance remains separate and unverified.


2026-10-25 dock correction: the padding-only fix was incomplete. The previous BottomAppBar clipper used full-screen X coordinates inside a horizontally inset dock. A local Stack/DockClipper now owns both notch and button; see IMPLEMENTATION_STATUS.md for diagnosis and nine geometry regression cases.
