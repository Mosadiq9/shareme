# Milestone 3 (M3): Native Discovery Layer — Implementation Plan (⚠️ Highest Risk)

**Current Status:** Milestone 2 (Local SQLite Data Layer) is **100% complete, analyzed (0 lints), built, and committed to git** (`commit 645e0b7`). Transfer history and customized device names now persist across app restarts using reactive Drift streams.

Per your verification protocol, here is the exact technical plan for **Milestone 3** for you and your developer to review before we begin coding.

---

## 🎯 Goal Description
Build the native peer discovery bridge enabling two nearby mobile devices to discover each other automatically within 2 seconds without requiring an internet connection or cellular data.

This is marked in our roadmap as the **⚠️ Highest Risk Milestone** because OEM modifications to Android's Wi-Fi Direct stack (especially Samsung and Xiaomi devices) require careful fallback handling between **Wi-Fi Direct P2P Service Discovery** and **mDNS (Bonjour/Network Service Discovery)**.

---

## ⚠️ User & Developer Review Required

1. **Dual-Discovery Protocol**: Per TRD §3.1–3.2, we propose implementing both Wi-Fi Direct Service Discovery (`WifiP2pManager`) AND Local LAN mDNS (`NsdManager` on Android, `NWBrowser`/`NWListener` on iOS). If Wi-Fi Direct discovery is blocked or slow on a specific OEM device, mDNS immediately discovers any peer connected to the same Wi-Fi hotspot or router.
2. **Platform Channel Interface (TRD §8 Contract)**:
   - `MethodChannel('com.mosadiq.shareme/discovery_methods')`: For commands (`startDiscovery`, `stopDiscovery`, `getNativePermissions`).
   - `EventChannel('com.mosadiq.shareme/discovery_events')`: For live streaming discovered peers (`PeerDevice` JSON maps) from native code up to Riverpod Notifiers.

---

## 🏗️ Proposed Architecture & Changes

### 1. Flutter Platform Bridge (`lib/features/discovery/data/`)
- **`NativeDiscoveryDataSource`**: Wraps MethodChannel and EventChannel.
- **`DiscoveryRepositoryImpl`**: Implements `DiscoveryRepository`, converting native raw JSON maps into our type-safe Freezed `PeerDevice` domain entities.

### 2. Android Native Implementation (`android/app/src/main/kotlin/com/mosadiq/shareme/`)
- **`DiscoveryHandler.kt`**: Manages `WifiP2pManager` lifecycle, broadcast receivers, and `NsdManager` registration.
- **`MainActivity.kt`**: Registers platform channels and routes permission requests (Location, Nearby Devices / `NEARBY_WIFI_DEVICES` for Android 13+).

### 3. iOS Native Implementation (`ios/Runner/`)
- **`DiscoveryManager.swift`**: Uses iOS 15+ Network framework (`NWListener` to advertise service `_shareme._tcp` and `NWBrowser` to scan for nearby phones).
- **`AppDelegate.swift`**: Registers channels and wires Apple Bonjour network permissions in `Info.plist`.

### 4. UI & State Connection (`lib/features/discovery/`)
- Update `mockDiscoveryProvider` (or create `realDiscoveryProvider`) to listen to `DiscoveryRepository.watchNearbyPeers()` stream when scanning is triggered on the Radar Screen.

---

## 🧪 Verification Plan

### Automated Verification
1. Run `flutter analyze` to verify zero interface errors.
2. Unit test platform channel mocking (`MockMethodChannel`) to verify proper serialization/deserialization of peer data structures.

### Physical Device Checkpoint (Critical)
1. Deploy build to two physical mobile devices (preferably Android + Android or Android + iOS).
2. Open ShareMe on both devices and tap **Receive** on Device A and **Send** on Device B.
3. Confirm Device A appears inside Device B's Radar screen within **2 seconds**.

---

## 🚦 Next Steps
**Please have your developer review this document.** If approved, reply with **"continue"** or **"approved"** to begin native implementation of Milestone 3!
