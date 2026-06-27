package com.mosadiq.shareme.transfer

/// Resume tracker — bitmap tracking for resumable transfers.
///
/// TRD §6.3: Receiver maintains a bitmap of received chunk sequence numbers.
/// On interruption, reports last-confirmed bitmap to sender on reconnect.
/// Sender resumes by only sending missing chunks.
///
/// Implementation deferred to M5.
class ResumeTracker {
    // Stub — M5 will implement:
    // - markChunkReceived(sequenceNumber)
    // - getMissingChunks() → List<Int>
    // - serializeBitmap() → ByteArray (for sending to peer)
    // - deserializeBitmap(data)
}
