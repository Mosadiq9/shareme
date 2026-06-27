/// ShareMe — File Picker Screen.
///
/// App Flow §1, Screen #4: Select file(s)/folder to send.
/// Live summary counter and category filter tabs.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shareme/core/mocks/mock_providers.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_spacing.dart';
import 'package:shareme/core/theme/app_typography.dart';
import 'package:shareme/core/utils/file_utils.dart';
import 'package:shareme/core/widgets/app_button.dart';
import 'package:shareme/features/transfer/domain/transfer_item.dart';
import 'package:shareme/routing/route_names.dart';

class FilePickerScreen extends ConsumerStatefulWidget {
  const FilePickerScreen({super.key});

  @override
  ConsumerState<FilePickerScreen> createState() => _FilePickerScreenState();
}

class _FilePickerScreenState extends ConsumerState<FilePickerScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Video', 'PDF', 'Image', 'APK', 'Audio', 'Archive'];

  @override
  Widget build(BuildContext context) {
    final availableFiles = ref.watch(mockAvailableFilesProvider);
    final selectedFiles = ref.watch(mockSelectedFilesProvider);

    final filteredFiles = _selectedCategory == 'All'
        ? availableFiles
        : availableFiles.where((f) => fileCategory(f.mimeType).toLowerCase() == _selectedCategory.toLowerCase()).toList();

    final totalSizeBytes = selectedFiles.fold<int>(0, (sum, f) => sum + f.sizeBytes);

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        title: const Text('Select Files'),
        actions: [
          TextButton(
            onPressed: () {
              if (selectedFiles.length == availableFiles.length) {
                ref.read(mockSelectedFilesProvider.notifier).clear();
              } else {
                ref.read(mockSelectedFilesProvider.notifier).selectAll();
              }
            },
            child: Text(
              selectedFiles.length == availableFiles.length ? 'Deselect All' : 'Select All',
              style: AppTypography.labelMedium.copyWith(color: AppColors.accentPulse),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Tabs
            SizedBox(
              height: 50,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat == _selectedCategory;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = cat);
                    },
                    selectedColor: AppColors.accentPulse,
                    backgroundColor: AppColors.surfaceCard,
                    labelStyle: AppTypography.labelSmall.copyWith(
                      color: isGrantedColor(isSelected: isSelected),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.accentPulse : AppColors.borderSubtle,
                    ),
                  );
                },
              ),
            ),

            // File List
            Expanded(
              child: filteredFiles.isEmpty
                  ? Center(
                      child: Text(
                        'No $_selectedCategory files found in storage.',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.screenMargin),
                      itemCount: filteredFiles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final file = filteredFiles[index];
                        final isSelected = selectedFiles.any((f) => f.id == file.id);

                        return _FileTile(
                          file: file,
                          isSelected: isSelected,
                          onTap: () => ref.read(mockSelectedFilesProvider.notifier).toggleSelection(file),
                        );
                      },
                    ),
            ),

            // Bottom Summary & Proceed Bar
            Container(
              padding: const EdgeInsets.all(AppSpacing.screenMargin),
              decoration: const BoxDecoration(
                color: AppColors.surfaceRaised,
                border: Border(top: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${selectedFiles.length} ${selectedFiles.length == 1 ? 'file' : 'files'} selected',
                          style: AppTypography.labelLarge,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          selectedFiles.isEmpty ? 'Tap items to add' : formatFileSize(totalSizeBytes),
                          style: AppTypography.bodySmall.copyWith(
                            color: selectedFiles.isEmpty ? AppColors.textMuted : AppColors.accentSignal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppButton(
                    label: 'Send Files',
                    icon: Icons.radar_rounded,
                    isDisabled: selectedFiles.isEmpty,
                    onPressed: () {
                      ref.read(mockDiscoveryProvider.notifier).startScanning();
                      context.pushNamed(RouteNames.radar);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color isGrantedColor({required bool isSelected}) => isSelected ? AppColors.textPrimary : AppColors.textMuted;
}

class _FileTile extends StatelessWidget {
  const _FileTile({
    required this.file,
    required this.isSelected,
    required this.onTap,
  });

  final TransferItem file;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cat = fileCategory(file.mimeType);

    return Material(
      color: isSelected ? AppColors.accentPulse.withValues(alpha: 0.1) : AppColors.surfaceCard,
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            border: Border.all(
              color: isSelected ? AppColors.accentPulse : AppColors.borderSubtle,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _categoryColor(cat).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_categoryIcon(cat), color: _categoryColor(cat)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      style: AppTypography.labelMedium.copyWith(
                        color: isSelected ? AppColors.textPrimary : AppColors.textPrimary.withValues(alpha: 0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceRaised,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(cat, style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                        ),
                        const SizedBox(width: 8),
                        Text(formatFileSize(file.sizeBytes), style: AppTypography.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
                activeColor: AppColors.accentPulse,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Video': return Icons.videocam_rounded;
      case 'Image': return Icons.image_rounded;
      case 'Audio': return Icons.audiotrack_rounded;
      case 'APK': return Icons.android_rounded;
      case 'PDF': return Icons.picture_as_pdf_rounded;
      case 'Archive': return Icons.folder_zip_rounded;
      default: return Icons.insert_drive_file_rounded;
    }
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Video': return const Color(0xFFFF7675);
      case 'Image': return const Color(0xFF74B9FF);
      case 'Audio': return const Color(0xFFA29BFE);
      case 'APK': return const Color(0xFF55E6C1);
      case 'PDF': return const Color(0xFFFAB1A0);
      default: return AppColors.textMuted;
    }
  }
}
