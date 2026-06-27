package com.mosadiq.shareme.bridge

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/// Flutter ↔ Native communication bridge.
///
/// TRD §8: Handles MethodChannel (Flutter → Native) and
/// EventChannel (Native → Flutter) contracts.
///
/// Implementation deferred to M3 (discovery) and M5 (transfer).
class ShareMeMethodChannel {
    companion object {
        const val CHANNEL_NAME = "com.mosadiq.shareme/native"
    }

    // Stub — M3/M5 will implement:
    // Flutter → Native methods:
    //   - startDiscovery()
    //   - stopDiscovery()
    //   - connectToPeer(peerId)
    //   - sendFiles(filePaths, peerId)
    //   - cancelTransfer(transferId)
    //
    // Native → Flutter events (via EventChannel):
    //   - onPeerFound(peerInfo)
    //   - onPeerLost(peerId)
    //   - onConnectionEstablished(peerId, band)
    //   - onProgress(transferId, percent, speedMBps, eta)
    //   - onTransferComplete(transferId)
    //   - onTransferFailed(transferId, reason)
}
