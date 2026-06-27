/// ShareMe — Base exception class.
///
/// All app-specific exceptions extend this. Never throw raw [Exception]
/// or generic strings — always use typed exceptions so callers can
/// handle specific failure cases.
library;

/// Base exception for all ShareMe-specific errors.
sealed class AppException implements Exception {
  const AppException({
    required this.message,
    this.stackTrace,
  });

  /// Human-readable error message.
  final String message;

  /// Optional stack trace for debugging.
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppException: $message';
}

/// Exception during device discovery (WiFi Direct or mDNS).
final class DiscoveryException extends AppException {
  const DiscoveryException({
    required super.message,
    super.stackTrace,
  });

  @override
  String toString() => 'DiscoveryException: $message';
}

/// Exception during pairing / handshake between devices.
final class PairingException extends AppException {
  const PairingException({
    required super.message,
    super.stackTrace,
  });

  @override
  String toString() => 'PairingException: $message';
}

/// Exception during file transfer.
final class TransferException extends AppException {
  const TransferException({
    required super.message,
    super.stackTrace,
  });

  @override
  String toString() => 'TransferException: $message';
}

/// Exception from the local storage / database layer.
final class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.stackTrace,
  });

  @override
  String toString() => 'StorageException: $message';
}

/// Exception from the file system (file not found, permission denied, etc.).
final class FileSystemException extends AppException {
  const FileSystemException({
    required super.message,
    super.stackTrace,
  });

  @override
  String toString() => 'FileSystemException: $message';
}

/// Exception from platform permissions (WiFi, storage, local network).
final class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.stackTrace,
  });

  @override
  String toString() => 'PermissionException: $message';
}
