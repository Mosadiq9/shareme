# ShareMe — Implementation Plan / Roadmap

## Document 06 — v1.0.0 (Final Foundation Doc)

---

## What it is

The milestone-by-milestone build order for Phase 1 — turns the other 5 docs (PRD, TRD, App Flow, Backend Schema, Frontend Guidelines) into a sequenced, testable plan. Each milestone has a deliverable you can actually check off, not a vague "work on X" line.

---

## Build Philosophy

- **Foundation-first, not feature-first** — data layer and native discovery come before polish, because everything else depends on them
- **Every milestone ends in something you can run and test**, not just code that compiles
- **The riskiest parts (native discovery, transfer engine) come early**, not late — if something in the core speed promise doesn't work, you need to know in week 2, not week 6
- **No milestone is "done" until its exit criteria is met** — not just "looks done"

---

## Milestone Map

### M0 — Project Setup
**Goal:** Antigravity workspace ready, repo structured exactly per TRD.
- Load all 5 prior docs into the Antigravity project as context
- Init repo, first commit (empty skeleton)
- Build folder structure exactly matching TRD §7 (Android Kotlin) and §7.1 (iOS Swift)
- **Model:** Gemini 3.5 Flash
- **Estimate:** 1–2 days
- **Exit criteria:** folder structure matches TRD line for line

---

### M1 — UI Shell (Static Screens)
**Goal:** All 10 App Flow screens exist and look final, running on mock data.
- Build every screen from App Flow §1, with every empty/loading/success/error state from §2
- Apply Frontend Guidelines tokens (color, type, spacing, Pulse Ring) — no backend wiring yet
- **Model:** Gemini 3.5 Flash, verify visually via Browser Subagent / device preview
- **Estimate:** 3–5 days
- **Exit criteria:** every state listed in App Flow §2 visually exists and matches Frontend Guidelines §2–§7
- **Depends on:** M0

---

### M2 — Local Data Layer
**Goal:** Schema A is real and the app persists data across restarts.
- Implement `devices`, `transfers`, `transfer_files`, `app_settings` tables (Backend Schema §A) with migrations from day 1
- Wire Home screen's history list and Settings screen's device-name field to real DB (still empty of real transfers at this point)
- **Model:** Gemini 3.5 Flash
- **Estimate:** 2–3 days
- **Exit criteria:** force-close and reopen the app — settings and (empty) history persist correctly
- **Depends on:** M1

---

### M3 — Native Discovery Layer ⚠️ highest-risk milestone
**Goal:** Two real devices can see each other on the Radar screen.
- Android: `WifiP2pManager` discovery + `NsdManager` mDNS fallback (TRD §3.1–3.2)
- iOS: `NWBrowser`/`NWListener` Bonjour discovery (TRD §3.2)
- Flutter↔Native bridge per TRD §8 interface contract
- Wire Radar screen to real discovery events (not mock data)
- **Model:** Gemini 3.1 Pro — this is genuinely hard networking code
- **Risk checkpoint:** test on at least one Samsung and one Xiaomi device here, not later — OEM WiFi Direct bugs are a known issue (per TRD §11) and need to surface early
- **Estimate:** 4–6 days
- **Exit criteria:** Radar screen shows a real second device within 2 seconds on both Android-Android and Android-iOS pairs; empty/error states trigger correctly when WiFi is off or permission denied
- **Depends on:** M1, M2

---

### M4 — Pairing & Band Negotiation
**Goal:** Tapping a device on Radar leads to a real, successful "Connected" state.
- Implement handshake sequence (TRD §4) and band negotiation algorithm (TRD §5)
- Wire Connecting screen to real handshake events
- **Model:** Gemini 3.1 Pro
- **Estimate:** 2–3 days
- **Exit criteria:** test all 3 band-mismatch combinations (both 6GHz / one 6GHz one 5GHz / both only 2.4GHz) and confirm the correct common band is selected every time
- **Depends on:** M3

---

### M5 — Core Transfer Engine ⚠️ most critical milestone
**Goal:** A real file actually moves between two devices, fast, and survives interruption.
- Chunking (4MB default), 4–8 parallel streams, per-chunk checksum, resume bitmap (TRD §6.1–6.4)
- AES session encryption (TRD §6.5)
- Wire Transfer Progress screen to real byte-level progress
- **Model:** Claude Opus 4.6 for the core logic — this is the highest-stakes code in the whole app; follow with a Claude Sonnet 4.6 review pass specifically checking for race conditions and resume-bitmap edge cases
- **Estimate:** 6–8 days
- **Exit criteria:** transfer a 100MB file successfully with correct final checksum; manually kill WiFi mid-transfer and confirm it resumes from the last completed chunk, not from zero
- **Depends on:** M4

---

### M6 — Error Handling & Edge Cases
**Goal:** Every critical edge case from App Flow is reproducible and recovers gracefully.
- Implement EC1–EC4 (App Flow §3) and the fallback matrix (TRD §9)
- Build out Transfer Failed screen + retry flow
- **Model:** Gemini 3.1 Pro
- **Estimate:** 3–4 days
- **Exit criteria:** manually trigger each of EC1–EC4 and confirm the app recovers via the exact path documented in App Flow §3
- **Depends on:** M5

---

### M7 — Real-Device Speed Testing & Tuning
**Goal:** Confirm actual throughput against PRD targets, tune what's tunable.
- Run the full device matrix from TRD §10 (budget Android, flagship Android, iPhone Pro, mixed pairs)
- Adjust chunk size and parallel-stream count based on real measured results, not assumptions
- **Model:** Gemini 3.5 Flash for quick iteration loops
- **Estimate:** 4–5 days
- **Exit criteria:** fill in a real benchmark table against PRD §9's best/average/worst-case targets; any gap is documented with a reason, not silently ignored
- **Depends on:** M5, M6

---

### M8 — Polish Pass
**Goal:** The app feels finished, not just functional.
- Apply Frontend Guidelines §8 voice rules to every error/empty string in the app
- Finish Pulse Ring animations + confirm reduced-motion fallback works
- **Model:** Gemini 3.5 Flash
- **Estimate:** 2–3 days
- **Exit criteria:** every screen's copy matches the voice rules; toggling OS reduced-motion setting removes all ring animation correctly
- **Depends on:** M6, M7

---

### M9 — Internal Beta (Dogfooding)
**Goal:** Find what testing missed, by actually using it.
- Use ShareMe for every real file transfer you personally do, for at least one full week
- Log every failure, slowdown, or confusing moment — no matter how small
- **Estimate:** 1 week minimum, runs in parallel with daily life, not a dedicated build sprint
- **Exit criteria:** zero unresolved crashes across a full week of real personal use
- **Depends on:** M8

---

## Dependency Chain (simplified)

```
M0 → M1 → M2 → M3 → M4 → M5 → M6 → M7 → M8 → M9
                  (M3 is the first hard wall — discovery must work
                   before pairing, transfer, or testing mean anything)
```

---

## Rough Total Timeline

**~5–7 weeks**, solo build with Antigravity agent assistance — assuming no major OEM-compatibility surprises in M3. If M3 reveals serious Samsung/Xiaomi WiFi Direct issues, budget an extra week there specifically; don't let that risk silently eat into M5's timeline instead.

---

## Definition of Done — Phase 1 Launch

- [ ] All 10 App Flow screens built with every state from App Flow §2
- [ ] Local data layer (Schema A) persists correctly across app restarts
- [ ] Android-to-Android WiFi Direct transfer works at the speeds targeted in PRD §9
- [ ] Android-to-iOS LAN-mode transfer works (slower than WiFi Direct, but functional)
- [ ] Band negotiation correctly selects highest common band in all tested combinations
- [ ] A transfer survives a mid-transfer disconnect and resumes without restarting
- [ ] All 4 critical edge cases (EC1–EC4) recover gracefully, not with a dead-end crash
- [ ] One full week of personal dogfooding with zero unresolved crashes

---

## Explicitly Deferred (unchanged from PRD §3.1 — not part of this roadmap)

Cross-network transfer (WebRTC), cloud relay, web client, Windows/macOS clients, group transfer, Bluetooth, accounts/payments. These get their own roadmap once Phase 1 ships and is validated with real use — building them now would mean tuning a transfer engine for problems Phase 1 was never meant to solve.
