/// ShareMe — File utility functions.
///
/// Pure functions for file-related formatting. No side effects.
library;

/// Formats a byte count into a human-readable string.
///
/// Examples:
/// - `formatFileSize(1024)` → `"1.0 KB"`
/// - `formatFileSize(1048576)` → `"1.0 MB"`
/// - `formatFileSize(1073741824)` → `"1.0 GB"`
String formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
}

/// Formats transfer speed in MB/s for display.
///
/// Uses [IBM Plex Mono] in the UI to prevent width jitter.
/// Example: `formatSpeed(45.2)` → `"45.2 MB/s"`
String formatSpeed(double mbPerSecond) {
  return '${mbPerSecond.toStringAsFixed(1)} MB/s';
}

/// Formats an ETA duration into a human-readable string.
///
/// Examples:
/// - `formatEta(Duration(seconds: 45))` → `"45s"`
/// - `formatEta(Duration(minutes: 3, seconds: 12))` → `"3m 12s"`
/// - `formatEta(Duration(hours: 1, minutes: 5))` → `"1h 5m"`
String formatEta(Duration duration) {
  if (duration.inHours > 0) {
    final minutes = duration.inMinutes.remainder(60);
    return '${duration.inHours}h ${minutes}m';
  }
  if (duration.inMinutes > 0) {
    final seconds = duration.inSeconds.remainder(60);
    return '${duration.inMinutes}m ${seconds}s';
  }
  return '${duration.inSeconds}s';
}

/// Returns a file type category from a MIME type string.
///
/// Used for grouping files in the picker and showing appropriate icons.
String fileCategory(String mimeType) {
  if (mimeType.startsWith('image/')) return 'Image';
  if (mimeType.startsWith('video/')) return 'Video';
  if (mimeType.startsWith('audio/')) return 'Audio';
  if (mimeType.startsWith('application/pdf')) return 'PDF';
  if (mimeType.contains('zip') || mimeType.contains('archive')) {
    return 'Archive';
  }
  if (mimeType.contains('apk') || mimeType.contains('android')) return 'APK';
  return 'Document';
}
