package com.mosadiq.shareme.discovery

/// mDNS/NSD discovery manager — wraps [NsdManager].
///
/// TRD §3.2: Cross-platform fallback path (Android↔iOS).
/// Registers service under `_shareme._tcp.local.`
/// with TXT record carrying device name, supported bands, app version.
///
/// Implementation deferred to M3.
class NsdDiscoveryManager {
    // Stub — M3 will implement:
    // - NsdManager.registerService()
    // - NsdManager.discoverServices()
    // - Service TXT record with metadata
}
