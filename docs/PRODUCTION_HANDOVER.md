# ShareMe — Production Engineering Handover Guide

Welcome to the definitive architectural and operational reference for **ShareMe Phase 1**. This document provides the complete technical handover for maintenance engineers, DevOps teams, and feature developers.

---

## 1. Application Identity & Platform Matrix
* **App Name:** ShareMe
* **Package Name (Android):** `com.mosadiq.shareme`
* **Bundle Identifier (iOS):** `com.mosadiq.shareme`
* **Flutter Version:** `3.44.0` (Stable Channel)
* **Android Targets:** Minimum SDK `23` (Android 6.0 Marshmallow), Target SDK `36` (Android 16)
* **iOS Target:** Minimum Deployment Target `15.0`
* **Core Stack:** Clean Architecture, Riverpod v2 (Code Generation), Drift (SQLite persistence), fpdart (`Either<Failure, T>` functional error handling).

---

## 2. Architectural Blueprint
ShareMe enforces strict separation of concerns across three layers:

```
[Presentation Layer] -> Riverpod Notifiers & Glassmorphism UI Components
         ↓ (calls)
[Domain Layer]       -> Abstract Repositories & Pure Business Enums / Models
         ↓ (implemented by)
[Data Layer]         -> Local SQLite Storage, TCP Socket Engines, Discovery Services
```

### Key Modules (`lib/features/`)
* `discovery/`: Native mDNS (LAN) discovery and Wi-Fi Direct peer scanning.
* `pairing/`: Band negotiation (2.4GHz vs 5GHz/6GHz) and session initiation.
* `transfer/`: High-speed binary TCP streaming, storage pre-checks, dynamic buffer scaling, and quarantine sandboxing.

---

## 3. High-Speed Wire Protocol & Security
ShareMe avoids slow HTTP wrappers in favor of direct raw TCP socket transmission (`port 8888`).

### Wire Packet Format (Binary Codec)
1. **Magic Bytes (4B):** `0x53, 0x48, 0x52, 0x4D` ("SHRM") confirming protocol authenticity.
2. **Payload Length (4B Uint32):** Big-endian byte count of the incoming metadata JSON header.
3. **Metadata Header (UTF-8 JSON):** Contains file ID, filename, total file size in bytes, and expected 32-byte SHA-256 digest.
4. **Raw File Chunks:** Streamed immediately after header decoding.

### Dynamic Buffer Scaling (TRD §7.1)
* **2.4GHz Band:** Allocated **64 KB** memory buffers for maximum packet loss resilience.
* **5GHz Band:** Allocated **256 KB** memory buffers for high-speed channel saturation.
* **6GHz Band:** Allocated **512 KB** memory buffers for ultra-wideband peak throughput (>40 MB/s).

### Cryptographic Quarantine Sandbox (TRD §8)
Incoming file bytes are written strictly into isolated app scratch directories (`getTemporaryDirectory()`). Only when the rolling SHA-256 hash matches the expected header digest exactly is the file released to permanent user storage (`getApplicationDocumentsDirectory()`). Mismatched payloads are shredded instantly.

---

## 4. Database Schema & Recovery Checkpoints
Persistence is powered by SQLite via Drift (`lib/core/database/`).

### Schema Tables
* **`transfer_sessions`**: Tracks active or historical transfer batches (`sessionId`, `peerDeviceName`, `status`, `direction`, timestamps).
* **`file_transfer_items`**: Tracks individual file jobs (`fileId`, `sessionId`, `fileName`, `sizeBytes`, `bytesTransferred`, `status`).

### Resumable Checkpoint Recovery (TRD §6)
If a Wi-Fi Direct connection drops midway through a 5GB file transfer, `TransferRecoveryManager` stores the exact byte offset checkpoint in SQLite. Upon peer reconnection within 30 minutes, the socket handshake transmits the offset map, instructing the sender to execute `file.openRead(startOffset)` and the receiver to open file sinks in `FileMode.append`.

---

## 5. Build Automation & ProGuard Rules
To generate optimized, obfuscated production binaries, run the automated helper script from the workspace root:

```powershell
.\build_release.ps1
```

### What `build_release.ps1` Does:
1. Executes `flutter clean` to wipe stale caches.
2. Runs `flutter analyze` ensuring zero interface or code quality regressions.
3. Invokes `flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/debug_info`.
4. Appends custom rules from `android/app/proguard-rules.pro` to protect native SQLite C bindings (`sqlite3_flutter_libs`) and Riverpod reflection symbols from R8 shrinking.

---

## 6. Engineering Verification Sign-Off
All 10 phase milestones (M0 through M9) have been executed, statically analyzed, and verified against the product requirements document. Phase 1 is officially complete and ready for deployment.
