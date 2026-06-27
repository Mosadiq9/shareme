package com.mosadiq.shareme.discovery

/// WiFi Direct discovery manager — wraps [WifiP2pManager].
///
/// TRD §3.1: Android-to-Android primary discovery path.
/// Calls `discoverPeers()` on launch (foreground only),
/// re-scans every 2 seconds while radar screen is open.
///
/// Implementation deferred to M3.
class WifiDirectManager {
    // Stub — M3 will implement:
    // - discoverPeers()
    // - PeerListListener callback
    // - Service record broadcast (device name, app version, supported bands)
    // - EventChannel push to Flutter UI
}
