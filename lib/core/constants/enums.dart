/// ShareMe — Enums used across the app.
///
/// Stored as TEXT with CHECK constraints in SQLite (Backend Schema §A).
/// Each enum maps directly to a database column's allowed values.
library;

/// Direction of a file transfer.
enum TransferDirection {
  /// This device sent the file(s).
  sent,

  /// This device received the file(s).
  received,
}

/// Status of a transfer session.
enum TransferStatus {
  /// Transfer created but not yet started.
  pending,

  /// Transfer actively sending/receiving data.
  inProgress,

  /// Transfer finished successfully, all checksums verified.
  completed,

  /// Transfer failed — see error reason for details.
  failed,

  /// Transfer cancelled by the user.
  cancelled,
}

/// Status of an individual file within a transfer batch.
enum FileTransferStatus {
  /// File queued for transfer.
  pending,

  /// File currently being transferred.
  inProgress,

  /// File transferred and checksum verified.
  completed,

  /// File transfer failed.
  failed,
}

/// WiFi band tiers — used in band negotiation (TRD §5).
enum WifiBand {
  /// 2.4GHz — universal, mandatory on all WiFi hardware.
  ghz2_4('2.4ghz'),

  /// 5GHz — faster, common on modern devices.
  ghz5('5ghz'),

  /// 6GHz — WiFi 6E/7, fastest, newest devices only.
  ghz6('6ghz');

  const WifiBand(this.value);

  /// The string value stored in the database.
  final String value;

  /// Parse a database string back to the enum.
  static WifiBand fromValue(String value) {
    return WifiBand.values.firstWhere(
      (band) => band.value == value,
      orElse: () => WifiBand.ghz2_4,
    );
  }
}

/// Device platform type.
enum DevicePlatform {
  /// Android device.
  android('android'),

  /// iOS device.
  ios('ios');

  const DevicePlatform(this.value);

  /// The string value stored in the database.
  final String value;

  /// Parse a database string back to the enum.
  static DevicePlatform fromValue(String value) {
    return DevicePlatform.values.firstWhere(
      (platform) => platform.value == value,
      orElse: () => DevicePlatform.android,
    );
  }
}

/// Connection method used between two devices.
enum ConnectionMethod {
  /// WiFi Direct — Android-to-Android primary path.
  wifiDirect,

  /// LAN via mDNS — cross-platform fallback path.
  lan,
}
