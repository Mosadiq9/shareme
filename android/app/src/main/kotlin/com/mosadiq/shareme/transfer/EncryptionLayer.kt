package com.mosadiq.shareme.transfer

/// AES session encryption layer.
///
/// TRD §6.5: AES-256 applied per chunk before transmission.
/// Session key exchanged via Diffie-Hellman during handshake.
/// Encryption/decryption on dedicated threads, separate from socket I/O.
///
/// Implementation deferred to M5.
class EncryptionLayer {
    // Stub — M5 will implement:
    // - generateSessionKey() → DH key exchange
    // - encryptChunk(chunk, sessionKey) → encryptedChunk
    // - decryptChunk(encryptedChunk, sessionKey) → chunk
    // - Runs on dedicated CPU thread, never blocks socket I/O
}
