# Prayer Wall: reference analysis and Flutter revamp plan

Status: design proposal only. No application changes or new artwork generated in this pass.

## What changes

Replace the painted pastoral illustration, repeated white bordered panels, outline buttons, and softly styled dashboard presentation. Build a character-led, mobile-first prayer app with sculpted matte characters, confident typography, colorful borderless surfaces, and restrained tactile interaction feedback.

Keep working prayer data, daily completion, answered status, journal persistence, system appearance preferences, and the Android widget bridge. Prayer completion must stay distinct from a prayer being answered.

## Reference observations

These observations describe the supplied images. Exact fonts, original color values, hidden interactions, and animation behavior cannot be established from screenshots. Proposed motion below is a design decision, not an observed property of the references.

### 1. Lavender daily-planning interface

- Off-white screen inside a lavender presentation background. The lavender outside the device is mockup framing, not app content.
- Large lavender feature panel anchors the screen. Orange, powder blue, and pink are reserved for secondary content blocks.
- Sculptural objects use rounded cuboids, thick torus shapes, smooth surfaces, directional light, and soft grounding shadows. The orange object extends above the panel, creating depth without another UI container.
- Black geometric sans-serif typography has circular counters, compact headlines, and relatively light supporting text. The two-line headline uses scale and weight rather than embellishment.
- The header balances an avatar, centered greeting/date, and circular search control. The hierarchy is understandable before reading individual labels.
- A horizontal date row establishes rhythm; the black selected date breaks the otherwise pale row. Small dots convey another state.
- Lower content is asymmetric: one tall orange card beside two shorter blocks. Rounded rectangles vary in proportion while retaining a common visual language.
- A nearly black capsule anchors bottom navigation; the selected icon receives a contrasting white circular surface.
- Avatar overlap communicates participants. Compact tinted pills communicate categories.
- Adopt: colored hierarchy, controlled asymmetry, asset overlap, strong selected navigation.
- Adapt: replace arbitrary abstract objects with biblical/prayer-related assets. Remove outlined date controls and search rings to honor the no-border requirement. Keep navigation labels for clarity.

### 2. “moimoi” character onboarding

- Oversized, very heavy lowercase wordmark establishes personality immediately. Broad rounded letterforms feel friendly without requiring pastel text.
- The composition uses oversized cropped characters at the edges, smaller characters toward the center, and generous variation in scale.
- Characters are simple rounded masses with soft dimensional shading. Bold black facial features, white eye shapes, and graphic hair create expression with very few parts.
- Coral, lime, blue, butter yellow, and pink coexist because silhouettes and materials remain consistent.
- A black speech bubble connects the characters to the interface. A looping fine black line adds movement to the static composition.
- The cool illustration field transitions to a warm, very light authentication area. Primary actions are visually simple, wide, and easy to locate.
- Adopt: recognizable faces, cropped character compositions, strong brand typography, and calm action placement.
- Adapt: create an original sheep identity. Use speech only when it communicates useful guidance. Preserve guest browsing rather than putting an authentication wall in front of prayer content.

### 3. Lime mascot onboarding and form

- The mascot is also the composition: its face occupies a large portion of the screen rather than sitting inside a small decorative icon.
- Giant white eyes, near-navy pupils, highlights, curved eyebrows, and a tiny nose create a strong focal point.
- A small tuft bridges the character silhouette and its identity. Cream and lime form a striking two-color system; dark navy anchors text and the main action.
- Partial circles and edge cutouts echo the mascot's rounded construction.
- Headlines are compact, heavy, and approachable; the form is vertically organized under the eyes.
- The form fields and some button labels appear too close in value to their green backgrounds. The reference is visually energetic, but those treatments should not be reproduced without contrast checks.
- Adopt: identifiable mascot features at very small sizes and continuity between character shapes and UI shapes.
- Adapt: avoid copying the green creature, full-screen neon, low-contrast fields, or the outlined secondary action. A prayer app should feel welcoming across difficult emotions.

### 4. Classroom community

- Flat organic figures overlap into a group. Each has a different silhouette and color, with tiny facial marks rather than detailed modeling.
- Mint, peach, aqua, pink, green, and black create a cheerful editorial palette. The black figure contributes contrast, not merely a shadow.
- Wide, heavy display lettering contrasts with a casual handwritten accent and smaller functional sans-serif text.
- Cropped figures make the onboarding feel like entering an existing community.
- The functional screen uses compact greeting/navigation, overlapping circular portraits, a colored room panel, and layered homework cards.
- Slight rotations make the cards feel like physical notes. The layers communicate plurality, although overlap can obscure content and reduce tap clarity.
- Adopt: sense of belonging, grouped character composition, compact functional screens, and varied card dimensions.
- Adapt: use the same chosen 3D character family throughout rather than mixing unrelated flat blob mascots into it. Keep interactive prayer rows level and readable; reserve overlap for illustrations or nonessential previews.

### 5. Toy-character collection

- The most coherent reference for material and character construction. Large rounded heads, small torsos, stubby limbs, and simple faces read as collectible vinyl toys.
- Soft studio light and contact shadows establish volume. Skin, clothing, and accessories are smooth; there is no painted landscape texture or realistic fur.
- Each character has a strong silhouette, a controlled clothing palette, and a small number of identifying props.
- Several views show character rotations or adjacent cropped characters. Dots and partial neighbors imply a carousel; motion itself cannot be confirmed from the screenshot.
- Background color usually belongs to the character's palette. Large character renders dominate, while text and buttons occupy predictable zones below.
- Lower examples combine large character crops with smaller image tiles. Translucent rounded shapes provide backing without heavy outlines.
- White text over light pastel areas is sometimes weak; broad uppercase labels and long supporting text also reduce refinement.
- Adopt: unified toy-like proportions, repeatable lighting, controlled materials, pose variations, and significant props.
- Adapt: one original lamb plus a small supporting cast, not a collection of unrelated animals. No character marketplace, ratings, costumes, or toy-selection interface unless a real product need emerges.

### 6. Health interface

- A strong orange opening screen is contrasted with pale functional screens. The surrounding peach glow and cast phone shadows belong to the presentation.
- The opening illustration carries energy; smaller illustrations on later screens are tied to specific functions.
- Color organizes categories: blue, yellow, mint, lavender, and pink. The tiles are distinguishable through fill and spacing rather than borders.
- Typography is relatively practical and compact; important actions and metric labels use heavier weights.
- Circular activity graphics and a matrix of dots turn tracking into a visual pattern. The schedule rows remain legible, with times on the left and grouped portraits on the right.
- Circular directional buttons provide consistent affordances. Soft shadows give separation without making every panel appear elevated.
- Adopt: illustration tied to function, useful color coding, clean task rows, and quiet spacing around dense content.
- Adapt: do not invent prayer scores, wellness metrics, or competitive streaks. Do not mix its comic-line illustration style with the chosen toy-character material.

## Chosen art direction: Little Flock, sculpted and graphic

“Little Flock” is the working design concept, not an approved rename. Prayer Wall remains the product name until selected otherwise.

Primary influence: reference 5's matte toy construction. Supporting influence: reference 2's simple expressive faces and cropped compositions. Interface structure: reference 1's color blocks and reference 6's functional restraint. Reference 4 informs belonging and grouped composition; reference 3 informs mascot recognition.

The result should feel like a carefully designed little object you want to keep nearby. Sculpted characters sit against graphic surfaces. Biblical familiarity comes from the lamb, olive branch, dove, seed, and journal rather than realistic scenery or historical ornament.

### Character construction

- Original ivory lamb with a head slightly larger than its torso, short legs, rounded hooves, drooping ears, and one identifiable three-lobed forehead tuft.
- Wool represented by a few broad rounded lobes, not individual hairs or fuzzy texture.
- Dark oval eyes, tiny curved mouth, restrained peach inner ears. Facial features remain readable in a small widget.
- Matte vinyl finish, broad soft highlights, shallow contact shadows, one consistent light direction and camera angle.
- One small lilac neckerchief may establish recognition. Avoid a costume wardrobe or multiple unrelated accessories.
- Expressions: welcoming, attentive, reflective, and gently pleased. Avoid exaggerated crying, frantic joy, or a mascot that appears disappointed when the user misses a day.
- Never put a cheerful celebration beside sensitive community prayer content. Character reactions belong to private checklist feedback and onboarding.

### Color proposal

Approximate proposed values, not sampled claims about the references:

| Role | Light mode | Dark mode |
|---|---|---|
| Canvas | #F7F8F5 | #181A21 |
| Main text | #191B24 | #F4F3F8 |
| Primary action | #6652D6 | #C4B8FF |
| Featured lilac surface | #D5CBFF | #39314E |
| Reflection blue | #D5E8FB | #263B4A |
| Gratitude butter | #F7DEA0 | #453B28 |
| Community mint | #D9EBCB | #2D3E31 |
| Small peach accent | #F5BDB0 | #51352F |

Primary button text uses white in light mode and dark ink on the pale dark-mode action. Verify all final foreground/background pairs. Use one dominant color and at most two supporting accents in a viewport. Dark mode needs its own surfaces and asset previews, not automatic inversion.

### Typography

Prototype Outfit for headings and DM Sans for functional text. These are proposed choices, not identified fonts from the screenshots. Bundle licensed font files rather than fetching them at runtime.

- Main headings: 30–34 logical pixels, weight 650–750, compact but readable line height.
- Section headings: 20–24, weight 650–700.
- Body: 15–16, weight 400–500, approximately 1.45 line height.
- Buttons and labels: 14–16, weight 600–650. Supporting metadata: 12–13 minimum by default.
- Sentence case. No decorative all-caps labels, handwritten functional text, randomly italicized words, or large wordmarks on every screen.
- Permit wrapping and text scaling. Never clip the title to preserve a mockup composition.

## Screen plan

### Today

Compact greeting and profile/settings control. One lilac feature composition with the lamb partly overlapping its upper edge, title “A moment to pray,” and a single “Start praying” action. Put the checklist immediately below, with “Add prayer” visible. A small scripture area may follow when it adds value. No daily challenge, urgency, fake time limit, or invented activity statistic.

### Prayer wall

Community requests remain the main content. Use quiet borderless surfaces, readable text, author/context, and a compact “I prayed” control. Topic filters use filled pills. Keep mascot art in the introductory or empty state, not on every person's prayer. Include enough neutral space for serious requests.

### My prayers and Android widget

Readable checklist with separate Active and Answered views. Completed rows show a check and “Prayed today”; avoid relying only on a faint strikethrough. Provide undo. Widget settings show a realistic compact preview with the same lamb, color tokens, and three selected prayer rows.

The native Android widget retains tappable rows and shared persistence. Artwork occupies a small header/corner area so titles remain useful. Long titles wrap within predictable limits. System widgets have platform constraints: the Flutter motion system does not automatically apply to Android RemoteViews. The native widget uses reliable immediate state updates instead of promising full Flutter-style animation.

### Circles

Small, purposeful illustration per circle category: dove for peace, grouped lambs for community, olive branch for family/hope. Circle name, short description, and one join action. Avoid turning every row into a competing hero.

### Journal

An open-book asset introduces the empty state. Once entries exist, writing becomes the focus. “Write a reflection” and a date are enough; remove repeated motivational filler. Use a warm pale surface distinct from the wall.

### Navigation and composition

Four labeled destinations: Today, Wall, My prayers, Journal. Reach Circles from the wall header; settings from the profile control. Check this navigation against existing Discover functionality during implementation. Use a floating dark navigation capsule with a colored active segment and short labels. Give it safe-area padding and adequate touch targets. On large screens, expand to a compact side rail and a content-first layout, not a stretched phone or a generic analytics dashboard.

## Asset production plan

Generate a master character sheet first and approve its construction before producing variants. Reuse that sheet as the reference for every subsequent generation. Each asset has a known screen, display size, crop, and meaning.

| Asset family | Deliverables | Use |
|---|---|---|
| Main lamb | Greeting, reflective seated, attentive/listening, gentle completion, resting, holding a journal | Today, feedback, empty states, journal |
| Community | Two-lamb composition and small flock composition | Circles and onboarding |
| Dove | One pose with olive sprig | Peace circle and relevant empty state |
| Olive branch | One sculpted sprig | Family/hope category |
| Mustard seed/sprout | Paired seed and sprout composition | Beginning a personal prayer list |
| Journal | One open-book composition | Journal entry point |
| App mark | Original lamb-head vector, with small-size simplification | App icon and brand |
| Functional icons | Home, wall, prayer list, journal, circles, add, check, settings | Navigation and controls |

This is approximately 12 principal illustrations plus a compact icon set, not 12 illustrations on every screen. Generate transparent individual cutouts with consistent materials, pose framing, and clean alpha. Export suitable 1x/2x/3x sizes after review; do not ship huge master renders for tiny UI spots. Check ivory characters on both pale and dark surfaces. Keep any shadow separate if it causes dark-mode halos.

Generation brief: original matte toy-like ivory lamb; oversized rounded head; short rounded limbs; broad sculpted wool lobes; drooping ears; three-lobed forehead tuft; dark oval eyes; small curved mouth; pale peach ears; small lilac neckerchief; soft studio light from upper left; consistent three-quarter view; transparent background; no text; no painterly texture; no realistic fur; no glossy plastic glare; no extra props beyond the specified pose.

Do not imitate a reference character's exact design. Raster generation supplies illustrations. Crisp functional icons are vector assets, not small AI-rendered pictures. Use a consistent 24-unit grid, rounded terminals, and an optical weight around 1.8–2 units, with filled selected variants. “No borders” applies to containers, not the internal strokes that make icons legible. Keyboard focus must remain visible, using a distinct fill and clear focus marker.

## Motion specification

Mobile consumer-app weighting: polished physical response first, fast task completion second, occasional playful character response third. No continuous bouncing or pulsing calls to action.

| Interaction | Feedback | Target timing |
|---|---|---|
| Primary button press | Scale 1 → .97 under touch; return with restrained spring | 90 ms press; 160–200 ms release |
| Prayer completion | Immediate state change; check appears; small fill transition; optional light haptic | 140–180 ms |
| Private checklist milestone | Lamb changes to gently pleased pose once, without blocking input | 250–350 ms |
| Navigation | Active filled segment moves; icon switches weight | 180–220 ms |
| Composer | Sheet enters from its origin, keyboard accommodated | 220–260 ms |
| Filter | Selection fill changes; results update without animating every card | 120–160 ms |
| Undo or error | Clear immediate feedback; no celebratory character motion | Immediate |

Honor Flutter's reduced-motion preference, suppressing scale/travel/character reactions while preserving state. No sound by default. No motion that delays a second tap. Do not shake forms or bounce distress-related content. Generated still images do not become fully articulated animations automatically: initial character motion uses transforms and pose changes. Any later Rive character requires a separate vector construction and rigging step.

## Flutter implementation plan

1. Establish color, typography, spacing, shape, and motion tokens. Build borderless button, filled filter, prayer row, surface, and labeled navigation components.
2. Produce a visual proof: Today in light and dark, My prayers, and an Android widget preview using the approved character master. Review those before generating the full asset family.
3. Generate and optimize the approved illustration variants. Add an asset manifest documenting role, size, and semantics. Add vector icons and the original app mark.
4. Replace presentation screens while retaining Riverpod state, persisted prayer IDs, completion dates, answered state, journal entries, and the Kotlin widget data channel. Do not reset local data during a visual migration.
5. Implement touch feedback with Flutter animation controllers/implicit transitions. Keep complex decorative rendering outside scrolling prayer rows. Use image precaching and repaint boundaries selectively.
6. Apply shared visual tokens to native Android RemoteViews separately. Rebuild the widget preview, test pinning, long titles, multiple instances, app-closed toggles, date rollover, and appearance changes on a device.
7. Validate 320/390/430 logical-pixel phones, tablet/desktop, large text, reduced motion, keyboard focus, contrast, loading/empty/error states, and all existing prayer persistence tests.

## Acceptance criteria

- No painted scenery, realistic wool, random abstract 3D decorations, copied mascots, or unrelated character styles.
- No border strokes on buttons or cards. Separation comes from fill, spacing, and only occasional soft elevation.
- Every visible asset has a product role. Every label names something useful. No generic hero slogans repeated throughout the app.
- The sheep remains recognizable at widget size. The artwork never obscures text or receives taps meant for a button.
- Community prayer content stays respectful. No prayer leaderboard, guilt-based streak, failure mascot, or gamified spiritual score.
- System light/dark, accessible controls, existing local data, and interactive Android widget behavior remain intact.
- Visual proof is reviewed before implementation and full asset generation. This document does not authorize a product rename or claim the community backend is connected.

## Story-derived asset refinement

Added October 25, 2026. Planning only; no new artwork or app changes in this pass.

The expanded asset library is a reusable production library, not a requirement to display more illustrations per screen. The application remains a modern prayer tool. Story references become compact sculpted objects or small scenes, with explicit scripture context where needed.

| Source | Asset interpretation | Placement |
|---|---|---|
| Lost sheep, Luke 15:4–7 (parable) | Original lamb beside a curved path; optional shepherd’s staff | Welcome and community invitation |
| Jesus calms the storm, Mark 4:35–41 | Small rounded fishing boat on two low wave shapes | Peace-themed reflection |
| Feeding the five thousand, John 6:9–13 | Five small barley loaves and two fish in a basket | Gratitude and generosity |
| Noah’s dove, Genesis 8:11 | Dove with one olive leaf; a small ark only in the expanded story scene | Hope-themed reflection |
| Good Samaritan, Luke 10:30–37 (parable) | Small oil vessel and neatly rolled bandage | Caring for others and support circles |
| Ruth gleaning, Ruth 2:1–17 | Barley bundle beside a small gathering basket | Provision, family support, faithfulness |
| Memorial stones, Joshua 4:1–7 | Twelve rounded stones grouped as a memorial, not a balancing spa tower | Remembered/answered prayers |
| Prodigal son, Luke 15:20–24 (parable) | Open doorway and folded robe as symbolic cues | Optional reflection on welcome and reconciliation |

These are design interpretations, not literal illustrations of every scene. The prodigal-son doorway is an invented visual cue, not a claimed detail of those verses. Do not present the main mascot as a participant in historical narratives. Do not use lost-sheep or prodigal-son imagery to label a returning user as lost or disobedient. Do not use the boat as a promise that difficult circumstances will immediately resolve.

Selected art language: original compact matte sculptures, combining reference 5’s soft toy volumes, reference 2’s graphic facial clarity, and references 1/6’s functional color composition. Reference 4 informs grouped silhouettes only. No painterly scenery, photoreal textures, arbitrary 3D rings, heavy gloss, or unrelated illustration families.

Production invariants: a single character model sheet; head/body and ear/tuft proportions; three-quarter camera with limited perspective; upper-left broad key light; ivory, lilac, muted apricot and controlled thematic accents; shallow contact shadows; identical eye construction; consistent object bevels. Generate one asset or composition at a time using approved master references. Record prompt, source reference, version, intended size and screen. Reject inconsistent outputs rather than masking inconsistency with color grading.

Placement limits are starting design constraints, subject to real layout review:
- Today: one lead illustration, about 112–160 logical pixels tall; checklist/action visible without scrolling on a typical phone.
- Wall and journal with real content: no repeated character thumbnails or giant hero. At most one small contextual illustration outside user content.
- Category imagery: 40–56 logical pixels, optically sized; navigation icons stay crisp 22–24-unit vectors.
- Empty state: 120–160 logical pixels and one actionable line of guidance.
- Native widget: 40–56 logical-pixel character spot in the header; three useful prayer rows take priority over artwork.
- No more than one lead illustration plus two small supporting spots in a typical viewport; skip those spots if content already feels busy.
- UI uses one dominant accent plus neutral surfaces; character color does not recolor every surrounding control.
- No card or button borders; use filled surfaces, whitespace and selective elevation. Preserve visible focus states.
- Readable user content outranks illustration placement at large text sizes. Crop or remove artwork before shrinking text.
- Animation is event-driven: button compression, check feedback, occasional single character reaction. No ambient bobbing or emotional reactions to sensitive prayers.

First production set: master lamb plus welcome/resting/completion poses; dove with olive leaf; small boat; bread-and-fish basket; remembrance stones. Validate these in Today light/dark, the content-heavy wall, and the widget before expanding into Ruth, Samaritan, and seasonal assets.

Sources:
- https://www.biblegateway.com/passage/?search=Luke+15%3A4-7&version=KJV
- https://www.biblegateway.com/passage/?search=Mark+4%3A35-41&version=KJV
- https://www.biblegateway.com/passage/?search=John+6%3A9-13&version=KJV
- https://www.biblegateway.com/passage/?search=Genesis+8%3A11&version=KJV
- https://bible.usccb.org/bible/luke/10
- https://www.biblegateway.com/passage/?search=Ruth+2%3A1-17&version=KJV
- https://www.biblegateway.com/passage/?search=Joshua+4%3A1-7&version=NKJV
- https://www.biblegateway.com/passage/?search=Luke+15%3A20-24&version=KJV
