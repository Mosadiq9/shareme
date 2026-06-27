# ShareMe — Technical Requirements Document

## v1.0.0 — Phase 1: Close-Range High-Speed Transfer (Implementation Blueprint)

---

## 1. Document Info

| Field | Value |
|---|---|
| Product Name | ShareMe |
| Version | v1.0.0 |
| Companion document | ShareMe_PRD.md |
| Scope | Discovery, pairing, band negotiation, chunked transfer, native module architecture |

---

## 2. High-Level Architecture

```
┌─────────────────────────────────────────────┐
│              Flutter UI Layer                │
│   (file picker, radar list, progress bar)     │
└───────────────────┬───────────────────────────┘
                     │ MethodChannel / EventChannel
┌───────────────────┴───────────────────────────┐
│           Platform Bridge Layer                │
├───────────────────┬───────────────────────────┤
│   Android Native    │      iOS Native           │
│   (Kotlin)          │      (Swift)              │
│                     │                            │
│ - WifiP2pManager    │ - Network.framework        │
│   (WiFi Direct)     │   (NWListener/NWConnection)│
│ - NsdManager (mDNS)  │ - Bonjour (NWBrowser)      │
│ - Socket transfer    │ - Socket transfer          │
│   engine (TCP)       │   engine (TCP)             │
└─────────────────────┴───────────────────────────┘
```

**Why this split:** Flutter handles only UI/state — every speed-critical operation (discovery, socket I/O, chunking, encryption) runs in native code, since Flutter's plugin ecosystem for WiFi Direct is outdated and adds overhead unacceptable for a speed-first product.

---

## 3. Discovery Protocol

### 3.1 Android-to-Android (Primary Path — WiFi Direct)

1. App calls `WifiP2pManager.discoverPeers()` on launch (foreground only)
2. System returns list of nearby WiFi Direct-capable peers via `WifiP2pManager.PeerListListener`
3. Each peer broadcasts a service record containing: device name, app version, supported WiFi bands (2.4/5/6GHz capability flags)
4. Peer list is pushed to Flutter UI via `EventChannel` for the radar view
5. Refresh interval: re-scan every 2 seconds while radar screen is open; stop scanning when screen is closed or app backgrounded (battery + Android 10+ background scan restrictions)

### 3.2 Android-to-iOS / Same-Router Fallback (mDNS/Bonjour)

1. Both devices register an mDNS service under a custom service type: `_shareme._tcp.local.`
2. Android side: `NsdManager.registerService()` + `NsdManager.discoverServices()`
3. iOS side: `NWBrowser` browsing for the same service type, `NWListener` advertising it
4. Service TXT record carries the same metadata as WiFi Direct path (device name, supported bands, app version)
5. This path requires both devices already joined to the **same WiFi router** — no group-forming, just discovery + direct socket connection over existing LAN

### 3.3 Fallback Chain Logic

```
Try: WifiP2pManager discovery (Android-Android only)
  → Success: proceed with WiFi Direct group formation
  → Fail/Timeout (3s): fall through

Try: mDNS/NSD discovery (any combination, requires shared router)
  → Success: proceed with LAN socket connection
  → Fail: show "no nearby devices found" — no further fallback in Phase 1
```

---

## 4. Pairing / Handshake Sequence

```
Device A (initiator)                Device B (target)
        │                                   │
        │── Tap on B in radar list ────────▶│
        │                                   │
        │── Connection request ─────────────▶│
        │                                   │── Auto-accept (Phase 1: no manual
        │                                   │   confirmation prompt — frictionless
        │                                   │   by design, since same-room trust
        │                                   │   is assumed)
        │◀───── Accept + capability info ───│
        │   (supported bands, max streams,  │
        │    device storage write-speed hint)│
        │                                   │
        │── Band negotiation (see §5) ──────▶│
        │◀──── Agreed band + port list ─────│
        │                                   │
        │═══ Socket connections opened ════│
        │   (N parallel TCP streams)         │
```

**Note on auto-accept:** Phase 1 prioritizes speed/frictionless UX over multi-party consent UI, since the target use case is two devices already physically controlled by people who trust each other in the moment. A "require manual accept" toggle can be added in a later phase as a security option — flagged as a v1.1+ consideration, not blocking for v1.0.0.

---

## 5. Band Negotiation Algorithm

```
1. Device A sends its supported band list: [2.4, 5, 6] (example)
2. Device B responds with its supported band list: [2.4, 5]
3. Compute intersection: [2.4, 5] ∩ [2.4, 5, 6] = [2.4, 5]
4. Select MAX of intersection = 5GHz
5. Both devices switch radio context to 5GHz before opening transfer sockets
6. If intersection = [] (theoretically impossible — 2.4GHz mandatory on all WiFi
   hardware) → hard fallback to 2.4GHz regardless
```

This logic is identical regardless of platform combination (Android-Android, Android-iOS) — it operates on advertised capability flags exchanged during handshake, not on platform-specific APIs.

---

## 6. Transfer Protocol

### 6.1 Chunking

- File is split into chunks (initial default: **4MB per chunk** — tuned during device testing; smaller chunks = faster resume granularity but more overhead, larger chunks = less overhead but coarser resume points)
- Each chunk gets a sequence number + SHA-256 checksum computed before send

### 6.2 Parallel Streams

- **4–8 parallel TCP socket connections** opened between sender and receiver (exact count selected at runtime based on device tier — flagship vs budget, detected via available CPU cores and benchmarked storage I/O speed)
- Chunks are distributed round-robin across open streams
- Each stream independently sends/acknowledges its assigned chunks

### 6.3 Resume Logic

- Receiver maintains a bitmap of received chunk sequence numbers
- On interruption, receiver reports last-confirmed bitmap to sender on reconnect
- Sender resumes by only sending missing chunks — never restarts from zero

### 6.4 Integrity Verification

- Each chunk checksum verified on arrival; mismatched chunks are re-requested individually (does not restart whole-file transfer)
- Final whole-file checksum verified after reassembly as a last-line confirmation

### 6.5 Encryption

- AES-256 applied per chunk before transmission, using a session key exchanged during handshake (Diffie-Hellman style key exchange over the initial control channel, before data channels open)
- Encryption/decryption happens on dedicated CPU threads separate from socket I/O threads, to avoid encryption becoming the bottleneck ahead of network/storage limits

---

## 7. Native Module Structure (Android — Kotlin)

```
/android/app/src/main/kotlin/com/shareme/
├── discovery/
│   ├── WifiDirectManager.kt       // WifiP2pManager wrapper
│   └── NsdDiscoveryManager.kt     // mDNS wrapper for cross-platform path
├── transfer/
│   ├── ChunkManager.kt            // splitting, checksum, sequencing
│   ├── StreamPool.kt              // manages N parallel TCP sockets
│   ├── ResumeTracker.kt           // bitmap tracking for resumable transfer
│   └── EncryptionLayer.kt         // AES session encryption
├── bridge/
│   └── ShareMeMethodChannel.kt    // Flutter <-> native communication
└── MainActivity.kt
```

## 7.1 iOS Module Structure (Swift)

```
/ios/Runner/
├── Discovery/
│   ├── BonjourBrowser.swift       // NWBrowser wrapper
│   └── BonjourAdvertiser.swift    // NWListener wrapper
├── Transfer/
│   ├── ChunkManager.swift
│   ├── StreamPool.swift           // NWConnection pool
│   ├── ResumeTracker.swift
│   └── EncryptionLayer.swift
├── Bridge/
│   └── ShareMeMethodChannel.swift
└── AppDelegate.swift
```

---

## 8. Flutter ↔ Native Interface Contract

| Method (Flutter → Native) | Purpose |
|---|---|
| `startDiscovery()` | Begin peer scanning (WiFi Direct + mDNS) |
| `stopDiscovery()` | Stop scanning (on screen exit/background) |
| `connectToPeer(peerId)` | Initiate pairing handshake |
| `sendFiles(filePaths[], peerId)` | Begin chunked transfer |
| `cancelTransfer(transferId)` | Abort an in-progress transfer |

| Event (Native → Flutter, via EventChannel) | Purpose |
|---|---|
| `onPeerFound(peerInfo)` | Update radar list |
| `onPeerLost(peerId)` | Remove from radar list |
| `onConnectionEstablished(peerId, band)` | Show "connected" state |
| `onProgress(transferId, percent, speedMBps, eta)` | Update progress UI |
| `onTransferComplete(transferId)` | Show success state |
| `onTransferFailed(transferId, reason)` | Show error + retry option |

---

## 9. Error Handling & Fallback Matrix

| Failure point | Fallback action |
|---|---|
| WiFi Direct group formation fails | Retry once → fall back to mDNS/LAN path |
| Band negotiation finds no match above 2.4GHz | Proceed on 2.4GHz, log for analytics |
| One parallel stream drops mid-transfer | Redistribute its pending chunks to remaining active streams |
| Checksum mismatch on a chunk | Re-request only that chunk, not full restart |
| Full connection lost | Pause transfer, attempt reconnect for 30s using ResumeTracker bitmap before marking failed |

---

## 10. Device Testing Matrix (for stream-count + chunk-size tuning)

| Tier | Example devices | What to benchmark |
|---|---|---|
| Budget Android (2.4/5GHz only) | Entry-level Android, 4-6 CPU cores | Optimal stream count likely 4 |
| Flagship Android (6GHz/WiFi 6E+) | Recent flagship Android | Optimal stream count likely 6-8 |
| iPhone Pro models (LAN mode only) | iPhone Pro-tier devices | Confirm LAN-mode ceiling speed, since WiFi Direct unavailable |
| Mixed pair (Android↔iOS) | Any combination | Confirm mDNS handshake time + sustained LAN throughput |

---

## 11. Out of Scope (Reaffirmed from PRD)

Cross-network (WebRTC), cloud relay, web client, Windows/macOS, group transfer, Bluetooth — none of these are touched by this TRD; this document covers only the Tier-1 close-range path.
