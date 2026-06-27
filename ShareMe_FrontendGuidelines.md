# ShareMe — Frontend Guidelines

## Document 05 — v1.0.0

---

## What it is

Design system and UI rules for ShareMe — covers color, type, spacing, motion, components, voice/copy, and accessibility. Every screen/state listed in the App Flow doc must be built using only what's defined here, so the app reads as one coherent product, not screens stitched together by different agents/sessions.

---

## 1. Design Direction (grounding)

**Subject:** A close-range file-transfer app whose entire value proposition is raw speed.
**Audience:** Tech-comfortable users — students, professionals — moving large files (notes, videos, songs) between devices in the same room.
**Each screen's one job:** stated explicitly in the App Flow doc (find a device / confirm a connection / show progress / confirm success). The UI should never make a screen do two jobs at once.

**Direction taken:** Instrument-panel feel, not a generic chat/social-app look. The app should feel like a speedometer or a radar display — numbers and motion are the content, not decoration around content. Avoiding the generic AI-app defaults (warm-cream-and-serif, acid-green-on-black, hairline-newspaper-grid) — none of those serve a "speed" product.

---

## 2. Color Tokens

| Token | Hex | Usage |
|---|---|---|
| `bg.base` | `#0B1020` | App background — ink-navy, not pure black (easier on eyes, still reads "technical") |
| `surface.card` | `#131A2E` | Cards, list items, sheets |
| `surface.raised` | `#1B2440` | Modals, elevated dialogs |
| `accent.pulse` | `#FF7A33` | Primary CTA, active/in-progress states — warm, kinetic, the "go" color |
| `accent.signal` | `#2DE1C2` | Connected/success states — distinct from `pulse` so "in progress" and "done" never look the same color |
| `accent.error` | `#FF5470` | Errors, failed states, destructive actions |
| `text.primary` | `#F2F4F8` | Headlines, body, primary numbers |
| `text.muted` | `#8A93A6` | Secondary labels, timestamps, helper text |

**Rule:** `accent.pulse` (orange) is reserved for things actively happening or actionable right now. `accent.signal` (teal) is reserved for completed/connected states only. Never use them interchangeably — this distinction is load-bearing for the at-a-glance reading of any screen (per App Flow's loading/success state split).

---

## 3. Typography

| Role | Typeface | Used for |
|---|---|---|
| Display | **Space Grotesk** | Big numbers — speed (MB/s), percentage, screen titles. Geometric, technical character, used with restraint (large sizes only) |
| Body | **Inter** | All body text, labels, buttons, descriptions |
| Data/Mono | **IBM Plex Mono** | Live numeric readouts — speed, ETA, file size. Monospace stops digits from jittering in width as numbers tick up during transfer |

**Type scale:** 32 / 24 / 18 / 16 / 14 / 12 (px), in steps that match this exact sequence — no arbitrary in-between sizes.

**Why mono for live numbers specifically:** a speed counter in a proportional font visibly "wobbles" in width as digits change (1 vs 4 vs 8 are different widths) — distracting on the one screen (Transfer Progress) where stability of the readout matters most. This is a deliberate, justified choice, not a default.

---

## 4. Spacing & Layout

- Base unit: **4px grid** — all padding/margin values are multiples of 4 (4, 8, 12, 16, 24, 32...)
- Screen horizontal padding: 20px standard
- Corner radius: **12px** for cards/buttons, **20px** for sheets/modals, **999px** (full round) for the device-avatar circles on the Radar screen
- Elevation: no drop-shadows on dark backgrounds (they're invisible/muddy on near-black) — use a 1px `surface.raised` border instead to separate elevated layers

---

## 5. Signature Element — "Pulse Ring"

One motif, reused meaningfully across the three screens where it's actually true to what's happening — not decoration:

- **Radar (Discovery) screen:** concentric expanding rings in `accent.pulse`, emanating outward from the device's own icon — literally a radar sweep, matches the screen's actual function
- **Connecting screen:** the same ring motif, but two rings (one per device) animate toward each other and merge on successful handshake
- **Transfer Progress screen:** the ring becomes the progress indicator itself — a circular ring that fills as bytes transfer, pulsing gently while active

This is the one place the app "spends its boldness" (per design restraint principle) — everywhere else stays quiet and disciplined.

**Reduced motion:** every Pulse Ring animation must have a static fallback (ring shown at current state, no animation) when the OS-level "reduce motion" accessibility setting is on — this is mandatory, not optional polish.

---

## 6. Component Rules

Every interactive component must define these states explicitly (mirrors the App Flow empty/loading/success/error principle, applied at component level):

| Component | Default | Pressed | Disabled | Loading | Error |
|---|---|---|---|---|---|
| Primary Button | `accent.pulse` fill, white text | 90% opacity | `surface.card` fill, `text.muted` text | Spinner replaces label, button stays same size (no layout shift) | N/A — buttons don't show error, the screen does |
| Device Card (Radar list) | `surface.card`, device name + platform icon | Slight scale-down (0.97) on tap | N/A | Skeleton shimmer (3 placeholder cards) while scanning | N/A |
| Progress Ring | `accent.pulse`, animated fill | N/A | N/A | Indeterminate pulse (no peer info yet) | Ring turns `accent.error`, pauses animation |
| Toast/Snackbar | `surface.raised`, bottom-anchored | N/A | N/A | N/A | `accent.error` left-border accent strip |

**Hard rule:** no button ever changes size when entering its loading state — content swaps internally, layout never shifts. This avoids the jarring "jump" that makes apps feel unpolished mid-transfer.

---

## 7. Iconography

- Base icon set: **Material Symbols (Rounded)** — used for all utility icons (back arrow, settings gear, file-type icons) so we're not reinventing iconography that already reads instantly to users
- One custom icon: the **device/radar icon** itself (used in the Pulse Ring signature element) — this is the one place a custom icon is justified, everything else stays standard
- Icon sizing: 20px (inline), 24px (buttons/nav), 48px (empty-state illustrations)

---

## 8. Voice & Microcopy Rules

Pulled directly from the App Flow's empty/error states — here's how they should actually read:

**Active voice, one verb per action, name stays consistent through the whole flow:**
- Button says "Send" → resulting screen says "Sending…" → completion toast says "Sent" (never "Transmitted" or "File delivered" — same root verb throughout, per App Flow's Home → Transfer Complete path)

**Errors state what happened and how to fix it — no apologies, no vagueness:**
- ❌ "Oops! Something went wrong, sorry about that."
- ✅ "Connection lost. Retry to resume from where it stopped."
- ❌ "Permission required to continue."
- ✅ "Turn on Local Network access in Settings to find nearby devices." (+ the actual deep-link button)

**Empty states are an invitation to act, not just a status:**
- Radar empty state: "No devices found yet. Open ShareMe on the other phone and keep both screens on." — not just "No devices found"
- Home empty state (no history): "Nothing sent yet. Tap Send to pick your first file." — not just "No history"

---

## 9. Platform Consistency

ShareMe uses **one design system across Android and iOS** — not Material on Android / Cupertino on iOS. Reasoning: the brand identity (Pulse Ring, instrument-panel feel) *is* the product's differentiator; splitting visual language by OS would dilute the one thing that makes ShareMe recognizably itself. (Precedent: Spotify, Discord, Notion all do this — cross-platform consistency over OS-native chrome.)

Exception: respect OS-level system behaviors that users expect regardless of brand (back-gesture navigation, native share sheet, native permission dialogs) — those stay platform-native since overriding them actively confuses users.

---

## 10. Theme Scope (Phase 1)

- **Dark mode only** in Phase 1 — matches the instrument-panel direction, and is the only theme being built/tested now
- Light mode is explicitly deferred — not a "dark mode default with light mode coming later this sprint," but a genuine Phase 2+ decision, to avoid double-building every screen against two token sets before the design itself is validated with real users
