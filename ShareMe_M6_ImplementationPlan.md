# Milestone 6 (M6): Error Handling & Edge Cases — Implementation Plan

**Current Status:** Milestone 5 (Core Transfer Engine) is **100% complete, analyzed (0 lints), built, and committed to git** (`commit 4517d4f`). Bounded 64KB TCP server/client streaming and SHA-256 binary packet validation are active.

Per your verification protocol, here is the exact technical plan for **Milestone 6** for you and your developer to review before we begin coding.

---

## 🎯 Goal Description
Implement robust error handling, connection drop recovery (resumable transfers), and edge-case protection (insufficient storage pre-checks) to guarantee app stability under adverse real-world conditions.

---

## ⚠️ User & Developer Review Required

1. **Resumable Transfers Protocol (TRD §6.1)**: If a transfer drops midway (e.g. at 1.2GB of a 4GB file), the receiver records the exact byte offset in SQLite (`HistoryDao`). Upon reconnection within 30 minutes, the receiver sends a `ResumeRequest(offset: 1200000000)` header. The TCP server seeks to that exact offset (`file.openRead(1200000000)`) instead of restarting from zero.
2. **Pre-flight Storage Check (TRD §6.2)**: Before opening socket write sinks, the receiving device queries OS storage space. If free space < total file size + 100MB buffer, the app immediately rejects the transfer with a `FileSystemFailure` displaying *"Insufficient storage space on device"*.
3. **Friendly UI Error Voice (Frontend Guidelines §8)**: All errors surface through our Result/Either pattern matching. No technical stack traces or generic *"Oops"* alerts are shown to end users.

---

## 🏗️ Proposed Architecture & Changes

### 1. Error Recovery Engine (`lib/features/transfer/data/recovery/`)
- **`TransferRecoveryManager`**: Manages offset persistence and resume handshakes between client and server.
- **`StoragePrecheck`**: Queries platform channels/path_provider for available disk quota.

### 2. Repository & State Updates (`lib/features/transfer/` & `HistoryDao`)
- Extend `LocalTransferRepository` to intercept socket disconnects, record progress snapshots to SQLite, and attempt automatic reconnection up to 3 times before flagging session as `failed`.
- Add retry and resume actions to `TransferNotifier`.

### 3. UI Error Alert Dialogs (`lib/core/presentation/widgets/error_dialog.dart`)
- Create reusable dynamic error dialog component styling actionable recovery steps (e.g. *"Free up 500MB storage or choose another destination"*).

---

## 🧪 Verification Plan

### Automated Verification
1. Run `flutter analyze` to verify zero interface errors.
2. Unit test `TransferRecoveryManager` offset calculation (asserting that seeking offset `1024` on a mock byte buffer transmits only remaining bytes).

### Manual / Visual Verification
1. Start transferring a large file.
2. Disable Wi-Fi midway through the transfer.
3. Re-enable Wi-Fi; tap "Resume" on the transfer screen and verify progress continues exactly from where it dropped.

---

## 🚦 Next Steps
**Please have your developer review this document.** If approved, reply with **"continue"** or **"approved"** to begin implementation of Milestone 6!
