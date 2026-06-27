/// ShareMe — Spacing system.
///
/// Direct translation of Frontend Guidelines §4.
/// Base unit: 4px grid — all padding/margin values are multiples of 4.
///
/// Corner radii:
/// - 12px for cards/buttons
/// - 20px for sheets/modals
/// - 999px (full round) for device-avatar circles on Radar screen
library;

/// All spacing values for ShareMe, based on a 4px grid.
///
/// Usage: `AppSpacing.sm` for 8px, `AppSpacing.screenPadding` for 20px, etc.
abstract final class AppSpacing {
  // --- Grid multiples ---

  /// 4px — Tightest spacing (icon-to-label inline gap).
  static const double xxs = 4;

  /// 8px — Small gap (between related elements).
  static const double xs = 8;

  /// 12px — Medium-small gap.
  static const double sm = 12;

  /// 16px — Standard gap (card internal padding).
  static const double md = 16;

  /// 20px — Screen horizontal padding (Frontend Guidelines §4).
  static const double lg = 20;

  /// 24px — Section separation.
  static const double xl = 24;

  /// 32px — Large section separation.
  static const double xxl = 32;

  /// 48px — Extra large (empty state icon to text).
  static const double xxxl = 48;

  // --- Screen-level ---

  /// Standard horizontal padding for all screens.
  static const double screenPadding = 20;

  // --- Corner Radii ---

  /// 12px — Cards, buttons, input fields.
  static const double radiusCard = 12;

  /// 20px — Bottom sheets, modals, elevated dialogs.
  static const double radiusSheet = 20;

  /// 999px — Full round for device-avatar circles on Radar screen.
  static const double radiusCircle = 999;

  // --- Icon Sizes (Frontend Guidelines §7) ---

  /// 20px — Inline icons (within text or small labels).
  static const double iconInline = 20;

  /// 24px — Button/nav icons.
  static const double iconButton = 24;

  /// 48px — Empty-state illustrations.
  static const double iconEmptyState = 48;

  // --- Elevation ---
  // No drop-shadows on dark backgrounds (Frontend Guidelines §4).
  // Use 1px borderSubtle instead. This constant is here for documentation.

  /// Border width for elevation separation (replaces shadows on dark BG).
  static const double elevationBorderWidth = 1;
}
