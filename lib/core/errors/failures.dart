/// ShareMe — Failure types for the Result pattern.
///
/// Used with [fpdart]'s [Either] type in repositories:
/// `Either<Failure, T>` — left is failure, right is success.
///
/// Repositories never throw. They return [Either<Failure, T>].
/// UI layer pattern-matches on the failure type to show the correct
/// user-facing message (per Frontend Guidelines §8 voice rules).
library;

/// Base sealed class for all failure types.
///
/// Each subtype carries enough information for the UI to display
/// a helpful, actionable error message — not "Oops! Something went wrong."
sealed class Failure {
  const Failure({
    required this.message,
    this.stackTrace,
  });

  /// User-facing error message (follows Frontend Guidelines §8 voice rules).
  final String message;

  /// Optional stack trace for debugging / crash reporting.
  final StackTrace? stackTrace;
}

/// Device discovery failed (no peers found, WiFi off, etc.).
final class DiscoveryFailure extends Failure {
  const DiscoveryFailure({
    required super.message,
    super.stackTrace,
  });
}

/// Pairing / handshake failed (timeout, rejected, band negotiation error).
final class PairingFailure extends Failure {
  const PairingFailure({
    required super.message,
    super.stackTrace,
  });
}

/// File transfer failed (stream dropped, checksum mismatch, etc.).
final class TransferFailure extends Failure {
  const TransferFailure({
    required super.message,
    super.stackTrace,
  });
}

/// Local database operation failed.
final class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.stackTrace,
  });
}

/// File system operation failed (file not found, no write permission, etc.).
final class FileSystemFailure extends Failure {
  const FileSystemFailure({
    required super.message,
    super.stackTrace,
  });
}

/// OS-level permission denied.
final class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.stackTrace,
  });
}

/// Catch-all for truly unexpected errors — should be rare.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required super.message,
    super.stackTrace,
  });
}

/// Security / quarantine violation (hash mismatch, rogue token).
final class SecurityFailure extends Failure {
  const SecurityFailure({
    required super.message,
    super.stackTrace,
  });
}
