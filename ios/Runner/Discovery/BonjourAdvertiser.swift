import Foundation

/// Bonjour advertiser — wraps NWListener for mDNS advertisement.
///
/// TRD §3.2: iOS side advertises as `_shareme._tcp.local.`
/// with TXT record carrying device name, supported bands, app version.
///
/// Implementation deferred to M3.
class BonjourAdvertiser {
    // Stub — M3 will implement:
    // - NWListener advertising _shareme._tcp.local.
    // - TXT record with device metadata
    // - Start/stop advertising lifecycle
}
