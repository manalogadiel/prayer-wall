# Optional asset motion handoff — Codex / Claude

Canonical design: MASTER_PLAN.md. The owner selected **Option A clean graphic dove**, confirmed by `design-references/08-approved-dove-confirmation.png`. Use `../assets/illustrations/characters/dove_master_v002.png` or `design-concepts/ollie-a-clean-graphic.png`. Never use the original physical 3D dove or the B/C alternatives as the master.

## What is already implemented

Static transparent dove, calm boat, open journal, and loaves/fish basket. Original simplified dove app mark. Flutter buttons scale to .97 for 90 ms while pressed and return over 180 ms. Reduced motion disables scale. Checking updates the persisted state. The focus dialog prevents duplicate saves. No character animation, SVG animation, layered rig, Rive, or Lottie is implemented.

## Optional first proof — dove blink

Preserve the approved pear silhouette, lavender wing/inset, ivory body, plum oval eyes and tiny highlights, peach beak/feet, sage sprig. Deliver an authored editable vector only if it matches the static art closely. Do not flatten or squash the whole PNG to imitate a blink.

Named groups: body, tail, wing, wing-inset, feet, head, eye-left-open, eye-right-open, eyes-closed, beak, olive-stem, olive-leaves. Record viewBox, eye positions, stacking order, and pivots in the vector source. No scripts, external resources, or runtime network dependencies.

Starting blink timing: close 70 ms, hold 40 ms, reopen 90 ms. One blink after a suitable explicit interaction; no timer loop, no motion reacting to distressing public text. Keep head and body still. Optional later head tilt: one small acknowledgement, only if it improves the experience. Static is acceptable and preferred when quality falls.

Use Flutter-controlled path/group switching or CustomPainter after checking current renderer support. SVG SMIL/browser animation is not automatically supported by Flutter SVG packages. Do not embed a WebView just to animate the mascot. Dependencies require justification. Reduced motion, offscreen, background, and disposal stop nonessential motion. Repeated taps must not queue animations or block input.

Android RemoteViews widget remains static. Preserve its immediate stable-ID daily completion and undo behavior.

## Handoff acceptance

- Match the owner-approved static identity at 128 px and 48 px in both themes.
- Provide editable source, layer map, pivots, trigger/timing/repetition/interruption rules.
- Include a static fallback and reduced-motion state.
- Record actual runtime/dependency versions and verification.
- Reject halos, flicker, shifted eyes, clipping, unrelated poses, or a return to toy rendering.
- Do not claim animation is finished merely because an SVG file exists.

This file supports a portable handoff to Claude; it does not authorize messaging an external service.
