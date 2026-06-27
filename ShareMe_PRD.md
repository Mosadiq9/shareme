# ShareMe — Product Requirements Document

## v1.0.0 — Phase 1: Close-Range High-Speed Transfer

---

## 1. Document Info

| Field | Value |
|---|---|
| Product Name | ShareMe |
| Version | v1.0.0 |
| Phase | Phase 1 — Local/Close-Range Transfer (MVP) |
| Status | Draft — ready for build |
| Platforms in scope | Android, iOS (LAN-mode only) |
| Platforms explicitly out of scope (this phase) | Web, Windows, macOS |

---

## 2. Problem Statement

Existing file-sharing apps (SHAREit, Xender, Zapya, Send Anywhere) solve "transfer without internet" but compromise on one of: speed, cross-platform reliability, ad-driven bloat, or same-time-online requirements. None of them push **maximum achievable throughput** on close-range transfers as their core differentiator — they treat speed as a side effect of WiFi Direct, not as the product's central promise.

**ShareMe Phase 1 exists to solve exactly one problem:** when two devices are physically near each other (≤5 meters), the file transfer should happen at the **maximum speed the hardware allows** — no compromise for range, no compromise for "universal compatibility" features that slow down the common case.

---

## 3. Goals (Phase 1)

- Transfer any file type (PDF, image, video, audio, documents, archives) between two devices in the same room at maximum achievable hardware speed
- Support Android-to-Android and Android-to-iOS (LAN mode)
- Auto-detect and lock onto the highest WiFi band common to both devices
- Zero account/signup required to use core transfer
- Pairing should take seconds, not minutes

## 3.1 Non-Goals (explicitly deferred to later phases)

- Cross-network transfer (different WiFi networks / cellular data) — Tier 2/3, later phase
- Cloud relay / store-and-forward — later phase
- Web app support — later phase
- Windows / macOS clients — later phase
- Bluetooth as a transfer method — cancelled, discovery-only consideration dropped entirely
- Group transfer (3+ devices simultaneously) — later phase
- Bookmarking / link-saving feature — later phase
- Monetization, subscriptions, storage tiers — later phase
- Long-range / "send anywhere" style internet transfer — later phase

---

## 4. Target Users

- Users physically co-located (same room, same hostel, same office) needing to move large files (lecture notes, videos, project files, songs) instantly
- Users without reliable/affordable mobile data who need an offline-first transfer method
- Android-heavy user base primarily; Android↔iOS as a secondary but required use case

---

## 5. Core User Flow

```
1. User A opens ShareMe → taps "Send" → selects file(s)
2. User B opens ShareMe → app auto-starts discovery (radar view)
3. Both devices appear in each other's nearby-device list automatically
4. User A taps User B's device from the list
5. Devices negotiate highest common WiFi band → form direct connection
6. File is split into chunks → sent across multiple parallel streams (encrypted)
7. Progress bar shown on both ends in real time
8. Transfer complete → file saved to receiver's device, confirmation shown
```

No QR code, no PIN entry, no manual IP typing required for the primary flow — those are deferred to later phases (cross-network use cases).

---

## 6. Functional Requirements

### 6.1 Device Discovery
- Auto-discovery radar: nearby devices running ShareMe on the same local broadcast domain appear automatically in a list
- Discovery must work without requiring users to already be on the same manually-joined WiFi network (Android-to-Android can form its own WiFi Direct group)
- Discovery refresh should be near-instant (<2 seconds to first appear)

### 6.2 Band Negotiation
- On pairing, both devices exchange their supported WiFi bands (2.4GHz / 5GHz / 6GHz)
- System selects the **highest common band** between the two devices (not simply the highest band of either device alone)
- If no common band beyond 2.4GHz exists, fall back to 2.4GHz (universal, mandatory on all WiFi chips)

### 6.3 File Selection
- Support all file types: documents, images, videos, audio, archives, APKs
- Support multi-file and folder selection in a single transfer batch
- No file size cap in Phase 1 (limited only by device storage and hardware speed)

### 6.4 Transfer Engine
- Primary path: WiFi Direct (Android-to-Android)
- Fallback path: Same-WiFi-router LAN transfer via mDNS discovery + TCP/HTTP (used for Android-to-iOS, since iOS does not expose WiFi Direct to third-party apps)
- File is split into chunks and sent across **4–8 parallel TCP streams** (exact count tuned per device tier during testing — flagship vs budget hardware)
- Transfer must be resumable — if interrupted, resume from last completed chunk rather than restarting from zero
- Each chunk is checksum-verified on arrival to guarantee data integrity

### 6.5 Security
- Light encryption (AES) applied to data in transit for this phase
- Rationale: protects against accidental/incidental interception if a third device is in WiFi range during transfer (e.g., shared hostel/cafe environment); acceptable trade-off of ~5–10% speed overhead for baseline privacy
- No login/account required; no data persisted on any server (Phase 1 has no server in the transfer path at all)

### 6.6 Progress & Completion UX
- Real-time progress bar (% complete, speed in MB/s, ETA) on both sender and receiver
- Transfer history list (recent sends/receives) stored locally on-device only
- Clear success/failure state with retry option on failure

---

## 7. Non-Functional Requirements

| Category | Requirement |
|---|---|
| Speed | Maximize throughput per band tier (see §9 targets) — primary success metric for this phase |
| Reliability | Transfer must survive minor signal fluctuation via resumable chunking |
| Battery | Discovery scanning must not cause excessive battery drain; scanning should pause when app is backgrounded (Android 10+ restrictions apply) |
| Compatibility | Must work across old/current/future WiFi band tiers (2.4 / 5 / 6 GHz) on both Android and iOS |
| Privacy | No file content ever leaves the local network in Phase 1 — zero cloud dependency |

---

## 8. Technical Architecture

- **Client UI:** Flutter (cross-platform shell for both Android and iOS)
- **Speed-critical transfer layer:** Native module — Kotlin/Java on Android (Flutter plugins for WiFi Direct are outdated/limited; native implementation required for performance)
- **iOS transfer layer:** Network framework + Bonjour (mDNS) for LAN-mode discovery and transfer — WiFi Direct is not available to third-party apps on iOS, so Android↔iOS always uses the LAN-fallback path, never true WiFi Direct
- **Discovery:** 
  - Android-to-Android: native WiFi Direct service discovery
  - Cross-platform (Android↔iOS) or same-router scenarios: mDNS/NSD discovery
- **Transfer protocol:** Chunked file split → parallel TCP socket streams → checksum verification per chunk → reassembly on receiver
- **Band detection:** Query device WiFi capabilities at runtime; negotiate common band before opening data connection

---

## 9. Speed Targets (Success Metrics)

| Band Tier | Best Case | Average Case | Worst Case |
|---|---|---|---|
| 2.4GHz | 10–15 MB/s | 5–10 MB/s | 2–5 MB/s |
| 5GHz | 40–50 MB/s | 25–35 MB/s | 8–15 MB/s |
| 6GHz (WiFi 6E/7) | 80–100+ MB/s | 50–70 MB/s | 20–30 MB/s |

**100GB file, close-range transfer:**

| Scenario | Best Case | Average Case | Worst Case |
|---|---|---|---|
| WiFi Direct (Android-Android) | ~30 min | ~1 hr | ~3 hrs |
| LAN fallback (Android-iOS) | ~35 min | ~1.1 hr | ~3 hrs |

---

## 10. Permissions Required

**Android:**
- `NEARBY_WIFI_DEVICES` (Android 13+) or `ACCESS_FINE_LOCATION` (older versions — required for WiFi scanning)
- `CHANGE_WIFI_STATE`, `ACCESS_WIFI_STATE`
- Storage/media access (file selection)

**iOS:**
- Local Network permission (iOS 14+) for mDNS/Bonjour discovery
- Photo library / file access permission for file selection

---

## 11. Risks & Open Issues

- OEM-specific WiFi Direct bugs (Samsung, Xiaomi historically flaky) — requires fallback to LAN mode even between two Android devices if WiFi Direct connection fails
- iOS feature gap is permanent — no path to true WiFi Direct speed on iOS due to Apple platform restriction; LAN-mode is the ceiling for iOS performance
- Exact optimal parallel stream count (4 vs 8) requires real-device testing across budget and flagship hardware tiers before finalizing
- Background discovery limitations on Android 10+ and iOS may affect "always discoverable" UX — may require foreground service

---

## 12. Out of Scope — Reference List (for future phase planning)

- Bluetooth (cancelled entirely as a transfer method)
- Web client (deferred — browsers cannot access raw WiFi Direct/local sockets)
- Cross-network transfer via WebRTC (Tier 2 — future phase)
- Cloud relay fallback (Tier 3 — future phase)
- Bookmarking/link-save feature
- Subscription tiers, storage limits, payments
- Group/multi-device simultaneous transfer
- Windows and macOS native clients
