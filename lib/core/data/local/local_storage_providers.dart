/// ShareMe — Local Storage Riverpod Providers.
///
/// Exposes AppDatabase singleton, DAOs, and Repositories to the UI layer.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shareme/core/data/local/app_database.dart';
import 'package:shareme/features/history/data/local_history_repository.dart';
import 'package:shareme/features/history/domain/history_repository.dart';
import 'package:shareme/features/home/domain/history_item.dart';
import 'package:shareme/features/settings/data/local_settings_repository.dart';
import 'package:shareme/features/settings/domain/settings_repository.dart';

/// Singleton instance of Drift AppDatabase.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// History Repository Provider.
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LocalHistoryRepository(db.historyDao);
});

/// Settings Repository Provider.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LocalSettingsRepository(db.settingsDao);
});

/// Reactive Stream of recent transfer sessions stored in SQLite.
final recentTransfersProvider = StreamProvider<List<HistoryItem>>((ref) {
  final repository = ref.watch(historyRepositoryProvider);
  return repository.watchRecentTransfers().map((either) => either.fold(
        (failure) => [],
        (items) => items,
      ));
});

/// Reactive Stream of the custom device display name.
final deviceDisplayNameProvider = StreamProvider<String>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return repository.watchDeviceName();
});

/// Future provider for the persistent install UUID.
final installUuidProvider = FutureProvider<String>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return repository.getOrCreateInstallUuid();
});
