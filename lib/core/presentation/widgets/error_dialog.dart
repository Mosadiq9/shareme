/// ShareMe — Actionable Error Dialog Widget.
///
/// Displays friendly, user-centric error guidance with actionable recovery buttons
/// (Frontend Guidelines §8 & TRD §6 UI voice).
library;

import 'dart:ui';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    required this.title,
    required this.message,
    required this.primaryActionLabel,
    required this.onPrimaryAction,
    super.key,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  final String title;
  final String message;
  final String primaryActionLabel;
  final VoidCallback onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required String primaryActionLabel,
    required VoidCallback onPrimaryAction,
    String? secondaryActionLabel,
    VoidCallback? onSecondaryAction,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ErrorDialog(
        title: title,
        message: message,
        primaryActionLabel: primaryActionLabel,
        onPrimaryAction: () {
          Navigator.of(ctx).pop();
          onPrimaryAction();
        },
        secondaryActionLabel: secondaryActionLabel,
        onSecondaryAction: secondaryActionLabel != null && onSecondaryAction != null
            ? () {
                Navigator.of(ctx).pop();
                onSecondaryAction();
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: const Color(0xFF1E222A).withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        elevation: 16,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  if (secondaryActionLabel != null) ...[
                    Expanded(
                      child: TextButton(
                        onPressed: onSecondaryAction ?? () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                        ),
                        child: Text(
                          secondaryActionLabel!,
                          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPrimaryAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        primaryActionLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
