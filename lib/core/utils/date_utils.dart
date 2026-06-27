/// ShareMe — Date/time utility functions.
///
/// All timestamps in the app are stored as epoch milliseconds (UTC)
/// per Backend Schema engineering principles. These functions convert
/// between epoch ms and human-readable strings.
library;

/// Formats an epoch-millisecond timestamp into a relative time string.
///
/// Examples:
/// - "Just now" (< 1 minute ago)
/// - "3m ago" (< 1 hour ago)
/// - "2h ago" (< 24 hours ago)
/// - "Yesterday"
/// - "3 days ago"
String formatRelativeTime(int epochMs) {
  final now = DateTime.now();
  final date = DateTime.fromMillisecondsSinceEpoch(epochMs);
  final difference = now.difference(date);

  if (difference.inSeconds < 60) return 'Just now';
  if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
  if (difference.inHours < 24) return '${difference.inHours}h ago';
  if (difference.inDays == 1) return 'Yesterday';
  if (difference.inDays < 7) return '${difference.inDays} days ago';

  // Older than a week — show date
  return '${date.day}/${date.month}/${date.year}';
}

/// Returns the current time as epoch milliseconds (UTC).
///
/// Used for all `created_at`, `started_at`, `last_seen_at` fields
/// in the local database.
int nowEpochMs() => DateTime.now().millisecondsSinceEpoch;
