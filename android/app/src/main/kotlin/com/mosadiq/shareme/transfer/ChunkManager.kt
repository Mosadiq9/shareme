package com.mosadiq.shareme.transfer

/// Chunk manager — file splitting, checksum computation, sequencing.
///
/// TRD §6.1: Files split into 4MB chunks (default, tunable).
/// Each chunk gets a sequence number + SHA-256 checksum before send.
///
/// Implementation deferred to M5.
class ChunkManager {
    // Stub — M5 will implement:
    // - splitFile(filePath, chunkSize) → List<Chunk>
    // - computeChecksum(chunk) → SHA-256 hash
    // - reassembleFile(chunks, outputPath)
}
