# Milestone 4 (M4): Pairing & Band Negotiation — Implementation Plan

**Current Status:** Milestone 3 (Native Discovery Layer) is **100% complete, analyzed (0 lints), built, and committed to git** (`commit 037a3c2`). Android (`WifiP2pManager`/`NsdManager`) and iOS (`NWBrowser`/`NWListener`) bridges are active and streaming real peer events up to Riverpod.

Per your verification protocol, here is the exact technical plan for **Milestone 4** for you and your developer to review before we begin coding.

---

## 🎯 Goal Description
Implement the **Pairing & Band Negotiation** protocol. Once a peer is selected on the Radar screen, the devices execute an encrypted handshake and dynamically negotiate the fastest available Wi-Fi frequency band (6GHz / 5GHz high-speed over 2.4GHz legacy).

---

## ⚠️ User & Developer Review Required

1. **Band Negotiation Priority (TRD §4.2)**:
   - Devices exchange supported frequencies. If both peers support **5GHz or 6GHz Wi-Fi Direct / Hotspot**, we mandate connecting on those bands to achieve speeds >40MB/s.
   - If the high-speed band negotiation drops or times out after **1500ms**, the protocol silently fallbacks to **2.4GHz** so the connection never fails completely for the user.
2. **Cryptographic Handshake**: We will generate a secure session nonce/token (SHA-256 hash of device identifiers + timestamp) exchanged during pairing initiation to prevent unauthorized interception before opening raw TCP transfer sockets in M5.

---

## 🏗️ Proposed Architecture & Changes

### 1. Domain Entities (`lib/features/pairing/domain/`)
- **`PairingRequest`**: Carries sender device info, selected file count, total size, session token, and supported bands (`['5GHz', '2.4GHz']`).
- **`PairingResponse`**: Returns negotiated band (`'5GHz'`), accepted port number, and handshake verification status.

### 2. Pairing Repository (`lib/features/pairing/`)
- **`PairingRepository`** interface & **`LocalPairingRepository`** implementation:
  - `Future<Either<Failure, PairingResponse>> negotiatePairing(PeerDevice peer, List<TransferItem> items)`
  - `Stream<PairingRequest?> watchIncomingPairingRequests()`

### 3. Native Platform Methods (`android/` & `ios/`)
- Add method calls to platform channels: `negotiateBand` and `connectToPeer`. On Android, this triggers `WifiP2pManager.connect(config)` specifying the high-speed operating frequency group.

### 4. UI & State Connection (`lib/features/pairing/` & `ConnectingScreen`)
- Connect `ConnectingScreen` to watch the real pairing repository. During the 1.5s connecting animation, the app negotiates the band and establishes the secure channel.

---

## 🧪 Verification Plan

### Automated Verification
1. Run `flutter analyze` to verify zero interface errors.
2. Unit test band negotiation algorithm (e.g. asserting that when Device A supports `['5GHz', '2.4GHz']` and Device B supports `['5GHz']`, the output negotiated band is strictly `'5GHz'`).

### Manual / Visual Verification
1. Launch app, pick files, select a discovered peer.
2. Verify Connecting screen displays status text updating from *"Negotiating 5GHz high-speed band..."* to *"Handshake verified. Connected!"*.

---

## 🚦 Next Steps
**Please have your developer review this document.** If approved, reply with **"continue"** or **"approved"** to begin implementation of Milestone 4!
