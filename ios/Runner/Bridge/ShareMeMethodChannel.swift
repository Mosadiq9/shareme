import Foundation
import Flutter

/// Flutter ↔ Native communication bridge (iOS).
///
/// TRD §8: Mirror of Android ShareMeMethodChannel.
/// Handles MethodChannel and EventChannel contracts.
///
/// Implementation deferred to M3 (discovery) and M5 (transfer).
class ShareMeMethodChannel {
    static let channelName = "com.mosadiq.shareme/native"

    // Stub — M3/M5 will implement the same contract as Android side
}
