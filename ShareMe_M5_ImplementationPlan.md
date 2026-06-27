# Milestone 5 (M5): Core Transfer Engine — Implementation Plan (⚠️ Most Critical)

**Current Status:** Milestone 4 (Pairing & Band Negotiation) is **100% complete, analyzed (0 lints), built, and committed to git** (`commit 10dc14b`). Cryptographic SHA-256 tokens and 5GHz/6GHz band prioritization fallback algorithms are verified and active.

Per your verification protocol, here is the exact technical plan for **Milestone 5** for you and your developer to review before we begin coding.

---

## 🎯 Goal Description
Build the high-speed TCP socket binary transfer engine capable of transferring large files (up to 100GB+) at speeds exceeding **40MB/s** while keeping memory consumption strictly under **50MB**.

This is marked in our roadmap as the **⚠️ Most Critical Milestone** because improper buffering or loading full files into RAM causes Out-Of-Memory (OOM) crashes on low-end Android devices.

---

## ⚠️ User & Developer Review Required

1. **Memory-Bounded Streaming (TRD §5.1)**: We mandate chunked streaming using Dart `Socket` and `File.openRead()`. Files will be read and transmitted in exact **64KB (65,536 bytes)** chunks. Never load entire files into memory.
2. **Binary Wire Format Contract (TRD §5.2)**: Every file transfer will strictly prepend a binary packet header:
   - `[File ID: 16 bytes UUID]`
   - `[File Name Length: 2 bytes unsigned int]`
   - `[File Name: UTF-8 string]`
   - `[File Size: 8 bytes unsigned 64-bit int]`
   - `[Expected SHA-256 Checksum: 32 bytes hex string]`
3. **On-the-fly Checksum Verification**: As chunks arrive on the receiving device and are written to storage via `File.openWrite()`, a SHA-256 hash is computed concurrently. Upon receipt of the final byte, if the calculated checksum does not match the header checksum, the corrupted file is quarantined and deleted immediately.

---

## 🏗️ Proposed Architecture & Changes

### 1. Transfer Protocol Engine (`lib/features/transfer/data/protocol/`)
- **`BinaryPacketCodec`**: Encodes and decodes the exact TRD §5.2 binary header bytes.
- **`TcpTransferServer`**: Listens on negotiated socket port `8888`, accepts peer connection, and streams file chunks from disk.
- **`TcpTransferClient`**: Connects to sender's IP address, parses headers, writes chunks to download directory, and verifies rolling SHA-256 digests.

### 2. Transfer Repository (`lib/features/transfer/`)
- Create `TransferRepository` interface & `LocalTransferRepository` implementation exposing:
  - `Stream<TransferProgress> watchProgress()`
  - `Future<Either<Failure, void>> sendFiles(List<TransferItem> items, String peerIp)`
  - `Future<Either<Failure, void>> receiveFiles(int port)`

### 3. UI & State Connection (`lib/features/transfer/` & `TransferScreen`)
- Connect `TransferNotifier` to invoke real socket transmission when pairing completes.
- Automatically persist completed/failed sessions to SQLite via `HistoryRepository` (built in M2).

---

## 🧪 Verification Plan

### Automated Verification
1. Run `flutter analyze` to verify zero interface errors.
2. Unit test `BinaryPacketCodec` to verify exact byte-level alignment when encoding and decoding mock file headers.

### Manual / Visual Verification
1. Initiate transfer between sender and receiver.
2. Observe live speedometer updating smoothly in real time (`MB/s` and ETA calculation).
3. Verify file appears intact in destination device storage after transfer completes.

---

## 🚦 Next Steps
**Please have your developer review this document.** If approved, reply with **"continue"** or **"approved"** to begin implementation of Milestone 5!
