/// ShareMe — Color tokens.
///
/// Direct translation of Frontend Guidelines §2 into Dart constants.
/// Every color in the app MUST come from this class — no inline hex values.
///
/// Rule: [accentPulse] (orange) = actively happening / actionable NOW.
///       [accentSignal] (teal) = completed / connected states ONLY.
///       Never use them interchangeably — this distinction is load-bearing.
library;

import 'package:flutter/material.dart';

/// All color tokens for ShareMe's dark-mode-only design system.
abstract final class AppColors {
  // --- Backgrounds ---

  /// App background — ink-navy, not pure black.
  /// Easier on eyes, still reads "technical."
  static const Color bgBase = Color(0xFF0B1020);

  /// Cards, list items, bottom sheets.
  static const Color surfaceCard = Color(0xFF131A2E);

  /// Modals, elevated dialogs, raised surfaces.
  static const Color surfaceRaised = Color(0xFF1B2440);

  // --- Accents ---

  /// Primary CTA, active/in-progress states — warm, kinetic, the "go" color.
  /// Reserved for things actively happening or actionable right now.
  static const Color accentPulse = Color(0xFFFF7A33);

  /// Connected/success states — distinct from [accentPulse].
  /// "In progress" and "done" must never look the same color.
  static const Color accentSignal = Color(0xFF2DE1C2);

  /// Errors, failed states, destructive actions.
  static const Color accentError = Color(0xFFFF5470);

  // --- Text ---

  /// Headlines, body text, primary numbers.
  static const Color textPrimary = Color(0xFFF2F4F8);

  /// Secondary labels, timestamps, helper text.
  static const Color textMuted = Color(0xFF8A93A6);

  // --- Derived / Utility ---

  /// Subtle border for elevation separation on dark backgrounds.
  /// Used instead of drop-shadows (which are invisible on near-black).
  static const Color borderSubtle = Color(0xFF1E2A45);

  /// Overlay for pressed states (10% white over current color).
  static const Color pressedOverlay = Color(0x1AFFFFFF);

  /// Disabled state overlay.
  static const Color disabledOverlay = Color(0x33000000);
}
