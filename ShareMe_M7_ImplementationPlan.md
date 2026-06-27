# Milestone 7 (M7): High-Speed Performance & Band Tuning — Implementation Plan

**Current Status:** Milestone 6 (Error Handling & Resumable Transfers) is **100% complete, analyzed (0 lints), built, and committed to git** (`commit dde200f`). Storage pre-flight verification, resumable byte seeking (`openRead(offset)`), and actionable UI error dialogs are fully integrated.

Per your verification protocol, here is the exact technical plan for **Milestone 7** for you and your developer to review before we begin coding.

---

## 🎯 Goal Description
Optimize socket buffering and transmission throughput to fully saturate 5GHz and 6GHz Wi-Fi Direct / Hotspot bands, achieving real-world speeds exceeding 40+ MB/s while maintaining strict bounded memory usage.

---

## ⚠️ User & Developer Review Required

1. **Dynamic Buffer Scaling (TRD §7.1)**: While standard transfers start with 64KB chunks for memory safety, when the band negotiator confirms a 5GHz High-Speed or 6GHz Ultra-Wideband connection, the TCP socket buffer dynamically scales up to 256KB or 512KB chunks. This dramatically reduces syscall overhead and saturates high-speed radio channels.
2. **Sliding Window Speed Moving Average (TRD §7.2)**: Instantaneous speed spikes can cause UI ETA flickering. We will implement a 5-tick exponential moving average (EMA) or sliding window to calculate a buttery smooth MB/s reading and remaining countdown.
3. **Zero-Retention Stream Flushing**: Ensure that socket write buffers explicitly yield back memory after flushing chunk iterations so multi-gigabyte transfers maintain a flat RAM footprint (<50MB total app memory).

---

## 🏗️ Proposed Architecture & Changes

### 1. Performance Engine (`lib/features/transfer/data/performance/`)
- **`BufferScalingStrategy`**: Dynamically calculates ideal chunk buffer size based on negotiated frequency band (2.4GHz vs 5GHz/6GHz) and live throughput feedback.
- **`SpeedMovingAverage`**: Computes smoothed transfer velocity and jitter-free ETA calculations.

### 2. Socket Server/Client Tuning (`lib/features/transfer/data/protocol/`)
- Upgrade `TcpTransferServer` and `TcpTransferClient` to utilize `BufferScalingStrategy` for chunk sizing during stream reads/writes.

### 3. UI Analytics Integration (`lib/features/transfer/presentation/`)
- Update transfer progress displays to showcase peak speed badges (e.g. *"⚡ 5GHz Ultra-Fast Mode Active — Peak: 52.4 MB/s"*).

---

## 🧪 Verification Plan

### Automated Verification
1. Run `flutter analyze` to ensure zero issues across all performance tuning utilities.
2. Unit test `SpeedMovingAverage` to verify speed smoothing curves under simulated fluctuating packet drops.

### Manual / Visual Verification
1. Initiate transfer simulation on 5GHz band.
2. Verify speed indicator smoothly stabilizes above 40 MB/s without ETA jumping erratically.

---

## 🚦 Next Steps
**Please have your developer review this document.** If approved, reply with **"continue"** or **"approved"** to begin implementation of Milestone 7!
