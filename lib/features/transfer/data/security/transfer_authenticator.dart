/// ShareMe — Transfer Cryptographic Authenticator.
///
/// Handles session PIN generation and secure token challenge verification
/// to prevent rogue connections on public hotspot bands (TRD §8.1).
library;

import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:logger/logger.dart';

class TransferAuthenticator {
  TransferAuthenticator({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;
  final Random _random = Random.secure();

  /// Generate a secure 6-digit numeric PIN for session pairing verification.
  String generatePin() {
    final pin = (_random.nextInt(900000) + 100000).toString();
    _logger.i('Generated secure session PIN: $pin');
    return pin;
  }

  /// Generate a SHA-256 HMAC handshake token derived from [pin] and [sessionId].
  String generateAuthToken({required String pin, required String sessionId}) {
    final key = utf8.encode(pin);
    final bytes = utf8.encode(sessionId);
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    return digest.toString();
  }

  /// Verify if [receivedToken] matches [expectedToken] using timing-safe comparison.
  bool verifyToken({required String expectedToken, required String receivedToken}) {
    if (expectedToken.length != receivedToken.length) {
      _logger.w('Authentication failed: token length mismatch');
      return false;
    }

    var result = 0;
    for (var i = 0; i < expectedToken.length; i++) {
      result |= expectedToken.codeUnitAt(i) ^ receivedToken.codeUnitAt(i);
    }

    final isValid = result == 0;
    if (isValid) {
      _logger.i('Peer handshake authentication successful.');
    } else {
      _logger.w('Security Alert: Mismatched authentication token rejected.');
    }
    return isValid;
  }
}
