/// ShareMe — Settings Screen.
///
/// App Flow §1, Screen #10: Device name, app version, about.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shareme/core/providers/app_state_providers.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_spacing.dart';
import 'package:shareme/core/theme/app_typography.dart';
import 'package:shareme/core/widgets/app_toast.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: ref.read(localDeviceNameProvider),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveName() {
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty) {
      ref.read(localDeviceNameProvider.notifier).updateName(newName);
      AppToast.showSuccess(context, message: 'Device display name updated!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          children: [
            Text('Device Visibility', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.sm),

            // Device Name Input Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This name will be broadcast to nearby phones via Wi-Fi Direct and mDNS.',
                    style: AppTypography.bodySmall.copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      labelStyle: AppTypography.labelSmall,
                      filled: true,
                      fillColor: AppColors.surfaceRaised,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.borderSubtle),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.borderSubtle),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.accentPulse, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _saveName,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentPulse,
                        foregroundColor: AppColors.textPrimary,
                      ),
                      child: const Text('Save Name'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            Text('Engineering Standards', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.sm),

            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Column(
                children: [
                  _StandardRow(title: 'State Management', val: 'Riverpod v2 + Codegen'),
                  Divider(height: 24),
                  _StandardRow(title: 'Architecture', val: 'Feature-Based Clean Architecture'),
                  Divider(height: 24),
                  _StandardRow(title: 'Design System', val: 'Vanilla CSS Tokens + IBM Plex Mono'),
                  Divider(height: 24),
                  _StandardRow(title: 'Data Layer', val: 'Drift SQLite Repository Pattern'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            Center(
              child: Column(
                children: [
                  Text('ShareMe v1.0.0-phase1', style: AppTypography.labelMedium),
                  const SizedBox(height: 4),
                  Text('Built with highest engineering quality.', style: AppTypography.labelSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StandardRow extends StatelessWidget {
  const _StandardRow({required this.title, required this.val});

  final String title;
  final String val;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.bodySmall),
        Text(val, style: AppTypography.labelSmall.copyWith(color: AppColors.accentSignal, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
