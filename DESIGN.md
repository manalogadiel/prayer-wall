---
name: Prayer Wall
description: An expressive prayer wall with soft graphic biblical art and readable personal words.
colors:
  primary: "#25262B"
  primary-dark: "#F0EFEA"
  on-primary-dark: "#25262B"
  canvas: "#F7F8F5"
  canvas-dark: "#262626"
  surface: "#FFFFFF"
  surface-dark: "#303034"
  action-top: "#FFFEFA"
  action-bottom: "#E9E9E3"
  action-fill: "#F4F4EF"
  action-ink: "#202126"
  dock: "#0D0E12"
  dock-muted: "#AAABB3"
  create: "#F9F9F3"
  create-ink: "#17181C"
  ink: "#191B24"
  ink-dark: "#F4F3F8"
  muted: "#535661"
  muted-dark: "#B8BCC9"
  lilac: "#D5CBFF"
  lilac-dark: "#39314E"
  blue: "#D5E8FB"
  blue-dark: "#263B4A"
  butter: "#F7DEA0"
  butter-dark: "#453B28"
  mint: "#D9EBCB"
  mint-dark: "#2D3E31"
  peach: "#F5BDB0"
  peach-dark: "#51352F"
  field: "#F0F1EE"
  field-dark: "#30333E"
  paper: "#EDF4FB"
  paper-dark: "#273540"
  formal: "#ECE7F6"
  formal-dark: "#302C40"
  wall: "#DDECE0"
  wall-dark: "#293C33"
typography:
  headline-large:
    fontFamily: "Outfit, sans-serif"
    fontSize: "34px"
    fontWeight: 600
    lineHeight: 1.12
    letterSpacing: "-0.7px"
  headline-medium:
    fontFamily: "Outfit, sans-serif"
    fontSize: "30px"
    fontWeight: 600
    lineHeight: 1.12
    letterSpacing: "-0.7px"
  headline-small:
    fontFamily: "Outfit, sans-serif"
    fontSize: "26px"
    fontWeight: 600
    lineHeight: 1.12
    letterSpacing: "-0.7px"
  title:
    fontFamily: "Outfit, sans-serif"
    fontSize: "22px"
    fontWeight: 600
    lineHeight: 1.12
    letterSpacing: "-0.7px"
  title-medium:
    fontFamily: "DM Sans, sans-serif"
    fontSize: "16px"
    fontWeight: 600
    lineHeight: 1.35
  body:
    fontFamily: "DM Sans, sans-serif"
    fontSize: "16px"
    lineHeight: 1.5
  body-medium:
    fontFamily: "DM Sans, sans-serif"
    fontSize: "14px"
    lineHeight: 1.5
  label:
    fontFamily: "DM Sans, sans-serif"
    fontSize: "12px"
    lineHeight: 1.4
rounded:
  sticky: "5px"
  control: "16px"
  selection: "20px"
  post: "22px"
  surface: "24px"
  dialog: "28px"
  navigation: "34px"
spacing:
  xs: "4px"
  sm: "8px"
  compact: "12px"
  md: "16px"
  gutter: "20px"
  lg: "24px"
  xl: "32px"
components:
  button-primary:
    textColor: "{colors.action-ink}"
    rounded: "{rounded.control}"
    padding: "14px 18px"
  button-secondary:
    textColor: "{colors.ink}"
    rounded: "{rounded.control}"
    padding: "14px 18px"
  input:
    backgroundColor: "{colors.field}"
    textColor: "{colors.ink}"
    rounded: "{rounded.control}"
    padding: "16px"
  surface:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink}"
    rounded: "{rounded.surface}"
    padding: "20px"
  post-paper:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    rounded: "{rounded.post}"
    padding: "24px 24px 20px"
  navigation-selected:
    textColor: "{colors.surface}"
    rounded: "{rounded.selection}"
  button-filled:
    backgroundColor: "{colors.action-fill}"
    textColor: "{colors.action-ink}"
    rounded: "{rounded.control}"
    padding: "14px 20px"
  navigation-dock:
    backgroundColor: "{colors.dock}"
    height: "64px"
  create-control:
    backgroundColor: "{colors.create}"
    textColor: "{colors.create-ink}"
---

# Design System: Prayer Wall

## Overview

**Creative North Star: "The Living Prayer Wall"**

A personal, expressive prayer wall pairs soft graphic biblical artwork with tactile writing materials. Neutral and off-white controls give colorful content room to breathe; lilac, blue, butter, mint and peach give topics and communities visual character. Confident headings, clear author rows and readable prayer text carry the experience.

The owner-approved Option A dove is binding: an ivory silhouette, lavender teardrop wing, plum eyes, peach beak and olive sprig. Matching original stickers share broad 2D shapes and light shading. Preserve the incumbent Flutter app and local data; its visual system serves an honest local experience.

**Key Characteristics:**
- Expressive materials with live, selectable prayer text.
- Soft graphic biblical art with a single approved dove identity.
- Monochrome filled controls, colorful content and calm readable spacing.
- Short state feedback with reduced-motion support.

## Colors

Content pastels distinguish subjects while neutral controls and ink keep writing central. Frontmatter contains the implemented values from `lib/app/theme.dart`, `lib/core/widgets.dart`, `lib/features/home.dart` and `lib/features/wall/post_design.dart`; paired `-dark` entries are the actual dark equivalents.

### Primary

- **Charcoal / Warm Off-white:** theme primary, selected chips, functional icons and input focus. Essential filled actions stay off-white in both themes; ActionButton uses the top-to-bottom gradient recorded by action-top/action-bottom.
- **Dock Black / Create White:** mobile navigation ground and raised central Create post circle. Active destination is white, inactive is dock-muted; the desktop selection uses a neutral ink tint.

### Secondary

- **Lilac, Reflection Blue, Gratitude Butter, Community Mint, Peach:** topic and community fills; butter also distinguishes sticky notes.
- **Paper, Formal, Wall:** material-specific writing surfaces, each with a dark counterpart.

### Neutral

- **Canvas / Surface:** page ground and raised reading/control surfaces.
- **Ink / Muted:** content and secondary supporting text.
- **Field:** filled form controls; neutral primary focus strokes remain functional feedback.

**The Colorful Content Rule.** Keep essential controls monochrome; preserve topical, community and post-material color.

**The Readable Material Rule.** Match each material to its theme-specific fill and current theme ink; decoration must yield to readable live text.

## Typography

**Display Font:** Outfit, with sans-serif fallback.
**Body Font:** DM Sans, with sans-serif fallback. Both are bundled locally with OFL licenses.

Headings are rounded and confident; body text stays direct and comfortable. The theme's headline and title roles are recorded in frontmatter. Body is the normal reading role; body-medium and label support forms and metadata. The wall uses a distinct Outfit post title (25px, 600, 1.15 line height, -0.5px spacing) and body (16px, 1.6); preview reduces these to 22px and 14px.

Avoid inventing an extra display typeface or handwritten control labels. Small mobile navigation labels (10px) and feed metadata (11px) are observed local exceptions, not a general text-size standard.

## Layout

The Flutter values map to logical pixels. The shared spacing rhythm is recorded in frontmatter; ordinary surfaces use 20px padding. Phone content gutters are 20px. At 1000px the shell replaces bottom navigation with a 220px rail. Wall reading width is capped at 680px, Community at 940px, and other surfaces at 1000px. Community becomes two columns when its available width reaches 700px, with 16px gaps.

SafeArea protects native controls. The status-bar overlay requests the actual scaffold canvas; the navigation bar remains transparent, with contrast enforcement disabled in source. Android edge-to-edge behavior still requires native evidence. Web viewport-fit, theme metadata, CSS ground and runtime theme synchronization match the canvas. This source treatment still requires native Android capture verification.

The wall surface composition and screen hierarchy belong in `.impeccable/surfaces/social-wall.md`, not as universal composition rules for every future screen.

## Elevation & Depth

Use tonal layering by default. Shared Surface and Community cards have no shadows or decorative strokes. Essential gradient ActionButtons use a soft black ambient shadow (9% alpha, offset 0/3, blur 10). The raised create circle uses Flutter elevation 2; the notched BottomAppBar uses its theme defaults rather than the retired capsule shadow. Sticky material alone uses a butter-tinted shadow (30% alpha, offset 0/7, blur 18), tape and fold; these material cues are appropriate to the owner's requested post styles.

**The Material Depth Rule.** Keep depth local to its role: subtle action lift or sticky-paper tactility, never a hard offset shadow applied to every card.

## Shapes

Soft corners distinguish controls, selections, content and sheets as recorded in frontmatter. Sticky material has small corners; other posts have rounder corners. Chips use stadium silhouettes. Community has straight rounded card edges and tall arch artwork windows: artwork width is 104px or 140px according to card width, height is 1.22 times width, top radius equals width, and bottom corners are 28px. It is taller than a semicircle. Large text removes the side artwork before reducing content space.

## Components

### Buttons

Filled, direct and responsive. ActionButton uses a warm off-white vertical gradient with dark action ink in both themes; secondary uses an 8% current on-surface tint with on-surface text. FilledButton uses the flat action-fill token and action ink. Disabled actions use 50% opacity. Shared theme buttons have a 48px minimum size. Pressable scales to .97 over 90ms and returns over 180ms with easeOutCubic; reduced motion removes the transform. Flutter ink/focus feedback remains available.

### Chips

Borderless stadium selection, surface at rest and primary when selected. Selected labels use on-primary. Tags use topical tint, 10px horizontal and 5px vertical padding, and 12px semibold text. Use semantic selected state alongside color.

### Cards / Containers

Shared surfaces are borderless, filled and padded. Post author and actions stay outside the decorated writing material. Paper uses faint ruled lines; Wall uses low-opacity masonry geometry; Formal centers its title in an inset editorial arrangement; Normal uses the neutral surface. The optional foreground sticker stays beside the footer; background stickers use low opacity (16% light, 13% dark).

### Inputs / Fields

Filled, gently rounded, and unbordered at rest. The focused input has a 2px primary stroke. Validation and failed save feedback remain visible, and input survives failure. A focus stroke is functional feedback, not a decorative card border.

### Navigation

Four destinations: Wall, Community, Prayers, Profile. Mobile uses a black rounded notched BottomAppBar (64px tall), with a raised off-white circular Create post FAB, 6px notch margin; no outer top padding offsets the centerDocked anchor and a 72px center gap. White selected icons and a 4px dot distinguish selection; inactive icons use dock-muted. Mobile names are available through semantics and tooltips rather than visible text labels. Desktop keeps visible labels and a neutral selected field on its rail. Settings is accessible only in Profile. The Wall header avatar opens Profile; the approved dove is the fallback when no optional device-local photo is set. Selection icons lift, tilt and scale once within 240ms; keyboard activation is immediate and reduced motion removes transforms. No looping animation.

### Profile identity

Profile starts with avatar, editable name and optional bio; Today / Journal / Saved follow. The editor uses the shared filled fields and monochrome save action. Circular photos use cover fit with the approved dove as decoding/no-photo fallback. Name (60 characters), bio (160) and optional photo remain device-local; failed saves retain the editor.

### Biblical artwork

Keep the approved dove master. Boat, bread/fish, journal, lamp, lamb and ark are matching static PNGs. Consult `design/asset-manifest.json` and embedded prompt provenance before creating derivatives. Artwork is independent of text. The sidecar snippets are portable visual translations of Flutter components, not production web source.

## Do's and Don'ts

### Do:
- **Do** preserve the owner-approved Option A dove identity and matching soft graphic artwork.
- **Do** keep readable live text central in every post material and theme.
- **Do** use filled surfaces and functional focus feedback.
- **Do** reduce decoration before clipping or shrinking large text.
- **Do** use brief state feedback and respect reduced motion.

### Don't:
- **Don't** add decorative borders to cards or buttons.
- **Don't** replace the approved identity with toy renders or historical candidate mascots.
- **Don't** turn a local sample interaction into a claim of public publication or membership.
- **Don't** use continuous icon loops or pretend a static PNG is an articulated character.

Not canonized: compact 11px category/metadata exceptions need future device readability review; the Formal preface was removed in the final manual edit; do not reintroduce it as a reusable eyebrow. Missing Android visual evidence is a verification gap, not a design token.

