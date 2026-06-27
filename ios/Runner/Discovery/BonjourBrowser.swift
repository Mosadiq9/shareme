import Foundation

/// Bonjour browser — wraps NWBrowser for mDNS discovery.
///
/// TRD §3.2: iOS side of cross-platform discovery.
/// Browses for `_shareme._tcp.local.` service type.
///
/// Implementation deferred to M3.
class BonjourBrowser {
    // Stub — M3 will implement:
    // - NWBrowser browsing for _shareme._tcp.local.
    // - Parse TXT record metadata (device name, supported bands, app version)
    // - Push discovered peers to Flutter via EventChannel
}
