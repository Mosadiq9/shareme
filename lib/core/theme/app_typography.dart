/// ShareMe — Typography system.
///
/// Direct translation of Frontend Guidelines §3.
///
/// Three typefaces, each with a specific justified purpose:
/// - [Space Grotesk]: Display — big numbers, speed, percentage, screen titles.
///   Geometric, technical character. Large sizes only.
/// - [Inter]: Body — all body text, labels, buttons, descriptions.
/// - [IBM Plex Mono]: Data — live numeric readouts (speed, ETA, file size).
///   Monospace stops digits from jittering as numbers tick up during transfer.
///
/// Type scale: 32 / 24 / 18 / 16 / 14 / 12 (px) — no arbitrary in-between sizes.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// All text styles for ShareMe.
///
/// Usage: `AppTypography.displayLarge` for hero numbers,
/// `AppTypography.bodyMedium` for standard text, etc.
abstract final class AppTypography {
  // ──────────────────────────────────────────────
  // Display — Space Grotesk (big numbers, titles)
  // ──────────────────────────────────────────────

  /// 32px — Hero numbers (transfer speed, percentage).
  static TextStyle displayLarge = GoogleFonts.spaceGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// 24px — Screen titles, section headers.
  static TextStyle displayMedium = GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ──────────────────────────────────────────────
  // Body — Inter (labels, buttons, descriptions)
  // ──────────────────────────────────────────────

  /// 18px — Large body, prominent labels.
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// 16px — Standard body text, button labels.
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// 14px — Secondary labels, list item subtitles.
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.5,
  );

  /// 12px — Captions, timestamps, fine print.
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  // ──────────────────────────────────────────────
  // Data / Mono — IBM Plex Mono (live readouts)
  // ──────────────────────────────────────────────

  /// 32px mono — Primary speed readout (e.g., "45.2 MB/s").
  /// Monospace prevents width jitter as digits change during transfer.
  static TextStyle dataLarge = GoogleFonts.ibmPlexMono(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// 18px mono — Secondary data (ETA, file size).
  static TextStyle dataMedium = GoogleFonts.ibmPlexMono(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// 14px mono — Tertiary data (chunk counts, small readouts).
  static TextStyle dataSmall = GoogleFonts.ibmPlexMono(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  // ──────────────────────────────────────────────
  // Button-specific
  // ──────────────────────────────────────────────

  /// 16px — Primary button text.
  static TextStyle buttonLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.0,
    letterSpacing: 0.5,
  );

  /// 14px — Secondary/small button text.
  static TextStyle buttonSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.0,
    letterSpacing: 0.3,
  );
}
