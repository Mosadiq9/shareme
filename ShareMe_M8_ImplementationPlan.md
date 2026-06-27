# Milestone 8 (M8): Security, Encryption & Final Polish — Implementation Plan

**Current Status:** Milestone 7 (High-Speed Performance & Band Tuning) is **100% complete, analyzed (0 lints), built, and committed to git** (`commit 4fef557`). Dynamic buffer scaling (up to 512KB for 5GHz/6GHz) and exponential moving average (EMA) speed smoothing are active.

Per your verification protocol, here is the exact technical plan for **Milestone 8** for you and your developer to review before we begin coding.

---

## 🎯 Goal Description
Implement cryptographic peer authentication (PIN/Token handshakes), enforce strict file quarantine verification before releasing payloads to storage, and finalize visual UI animations and haptic feedback.

---

## ⚠️ User & Developer Review Required

1. **Peer PIN / Token Authentication (TRD §8.1)**: To protect against rogue socket connections on shared Wi-Fi Direct or hotspot networks, when a peer connects to port 8888, the client must first transmit an authentication packet containing the pairing token or 6-digit PIN. The server validates this token against the active session before opening file read streams.
2. **Quarantine Verification Pipeline (TRD §8.2)**: Incoming file chunks are written exclusively to the secure app temporary directory (`getTemporaryDirectory()`). Only after the rolling SHA-256 hash matches the 32-byte header digest exactly is the file renamed/moved to the final destination folder. If validation fails, the temp file is shredded immediately.
3. **Haptic & Audio Feedback Polish (Frontend Guidelines §3)**: Trigger subtle success vibrations/animations when transfers complete to give the app a premium, tangible feel.

---

## 🏗️ Proposed Architecture & Changes

### 1. Security & Handshake Engine (`lib/features/transfer/data/security/`)
- **`TransferAuthenticator`**: Validates session PINs and generates cryptographic handshake tokens for socket establishment.
- **`QuarantineManager`**: Enforces strict sandbox containment during transfer and verifies SHA-256 before releasing files to system folders.

### 2. Socket Engine Security Hook (`lib/features/transfer/data/protocol/`)
- Update `TcpTransferServer` and `TcpTransferClient` to execute the token authentication challenge before sending file headers.

### 3. UI Polish & Haptics (`lib/features/transfer/presentation/`)
- Add haptic feedback and celebration animation triggers upon successful file transfer completion.

---

## 🧪 Verification Plan

### Automated Verification
1. Run `flutter analyze` ensuring zero interface errors across all security managers.
2. Unit test `QuarantineManager` ensuring mismatched SHA-256 hashes trigger temp file deletion and throw `SecurityFailure`.

### Manual / Visual Verification
1. Attempt connecting to the TCP server socket with an invalid auth token and verify the server immediately drops the connection.
2. Complete a transfer and verify haptic vibration and celebratory badge trigger cleanly.

---

## 🚦 Next Steps
**Please have your developer review this document.** If approved, reply with **"continue"** or **"approved"** to begin implementation of Milestone 8!
