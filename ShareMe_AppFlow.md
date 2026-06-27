# ShareMe — App Flow

## Document 03 — v1.0.0 (Phase 1)

---

## What it is

Complete inventory of every screen, every state a screen can be in, and every transition between them — the state machine of ShareMe Phase 1 (close-range transfer).

---

## 1. Screen Inventory

| # | Screen | Auth? | Purpose |
|---|---|---|---|
| 1 | Splash | No | App launch, permission check |
| 2 | Permission Request | No | Request WiFi/Storage/Local Network access |
| 3 | Home | No | Choose Send or Receive, view recent transfer history |
| 4 | File Picker | No | Select file(s)/folder to send |
| 5 | Radar (Discovery) | No | Show nearby devices in range |
| 6 | Connecting (Pairing) | No | Band negotiation + handshake in progress |
| 7 | Transfer Progress | No | Live progress, speed, ETA |
| 8 | Transfer Complete | No | Success confirmation, file location |
| 9 | Transfer Failed | No | Error reason + retry |
| 10 | Settings | No | Device name, app version, about |

No screen requires login/payment — Phase 1 has zero accounts, zero paywalls.

---

## 2. Screen States

Each screen's required states (empty / loading / success / error / locked):

| Screen | Empty | Loading | Success | Error | Locked |
|---|---|---|---|---|---|
| Splash | — | Checking permissions | Auto-advance to Home/Permission screen | — | — |
| Permission Request | — | — | Granted → proceed | Denied → show "Open Settings" CTA | Screen itself is a lock — blocks app until resolved |
| Home | No transfer history yet ("Send your first file") | — | Send/Receive buttons + recent history list | — | — |
| File Picker | No files selected yet | Scanning device storage | File(s) selected, "Next" enabled | Storage permission denied | — |
| Radar | No nearby devices found ("Make sure both devices have ShareMe open") | Scanning (spinner + "Searching…") | Device(s) found, tappable list | WiFi/Local Network off or permission denied | — |
| Connecting | — | Negotiating band + handshake ("Connecting…") | Auto-advance to Transfer Progress | Connection failed/timeout → retry CTA | — |
| Transfer Progress | — | Initializing chunks | Live progress bar, % / MB/s / ETA | Stream dropped → "Reconnecting…" then fail after 30s | — |
| Transfer Complete | — | — | Checkmark, file name, "Open" / "Done" | — | — |
| Transfer Failed | — | — | — | Reason shown + "Retry" + "Cancel" | — |
| Settings | — | — | Device name editable, version shown | Save failed (rare, local-only) | — |

---

## 3. User Journeys

### Happy Path

```
Splash → Permission granted → Home → tap "Send" → File Picker →
select file(s) → Radar → tap target device → Connecting →
auto-connect success → Transfer Progress → Transfer Complete
```

### Critical Edge Cases

**EC1 — Permission denied at launch**
`Splash → Permission Request (denied) → "Open Settings" deep link → OS Settings → user grants → return to app → resumes at Home`

**EC2 — No nearby devices found**
`Radar (empty state after timeout) → tip shown ("move closer / check both apps are open") → user retries scan or backs out to Home`

**EC3 — Connection drops mid-transfer**
`Transfer Progress → stream lost → "Reconnecting…" (auto-resume via chunk bitmap, 30s window) → reconnect success: resumes from last chunk, OR reconnect fails: Transfer Failed → user taps Retry → re-enters Radar/Connecting flow`

**EC4 — Band mismatch (only 2.4GHz common)**
`Connecting succeeds normally → Transfer Progress shows a subtle "slower connection" indicator → transfer still completes, just at reduced speed → non-blocking`

---

## 4. Permissions per Screen

| Screen | Permission(s) needed | Platform notes |
|---|---|---|
| Home | None | — |
| File Picker | Storage / Media access | Android: media permission; iOS: Photos/Files access |
| Radar | Nearby WiFi Devices / Location | Android 13+: `NEARBY_WIFI_DEVICES`; older Android: `ACCESS_FINE_LOCATION`; iOS: Local Network permission |
| Connecting | Same as Radar (already granted by this point) | — |
| Transfer Progress | None additional | — |
| Settings | None | — |

No screen is gated behind login or payment in Phase 1 — gating is permission-based only (OS-level), not account-based.

---

## 5. Entry & Exit Points

**Entry points:**
- Cold start from app icon (most common) → Splash
- *(Extra, suggested for v1.1)* OS Share Sheet entry — user shares a file directly from Gallery/Files app into ShareMe → skips Home, lands directly on Radar with file pre-selected

**Exit points / fallbacks:**
- Back button on Radar/Connecting → returns to Home, cancels any in-progress discovery
- Back button during active Transfer Progress → confirmation dialog ("Cancel transfer?") before exiting, to avoid accidental data loss
- Permission denied → redirect deep link to OS Settings app, not a dead-end screen
- Transfer Failed → "Retry" re-enters Radar (not all the way back to File Picker, so the user doesn't have to reselect files)
- App backgrounded mid-transfer → transfer pauses (per OS background restrictions noted in TRD §3.1) → resumes automatically on foreground via ResumeTracker bitmap

---

## Note on AI-builder handoff

Per template guidance: empty and error states for every screen above are fully specified — not left as an afterthought — so that an AI builder (or any developer) implementing this flow can't ship a version that only looks good with seeded demo data.
