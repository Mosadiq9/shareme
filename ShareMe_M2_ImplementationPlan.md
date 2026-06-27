# Milestone 2 (M2): Local SQLite Data Layer — Implementation Plan

**Current Status:** Milestone 1 (UI Shell & Mock State) is **100% complete, analyzed (0 lints), built, and committed to git**. All 10 UI screens are fully interactive and responsive.

Per your verification protocol (*"make phase by phase implementation plan then me and my developer will verify if any change then we will let you know and then our go you have to went for proceed"*), here is the exact technical plan for **Milestone 2** for you and your developer to review before we begin coding.

---

## 🎯 Goal Description
Implement the persistent local relational database using **Drift (SQLite)**. This replaces the M1 in-memory mock history with a robust, reactive SQLite storage engine that permanently records all sent/received transfers, tracks file items, and saves user settings across app restarts.

---

## ⚠️ User & Developer Review Required

1. **Drift Reactive Engine**: We propose using **Drift** (over raw Sqflite or Hive) because it provides compile-time verification of SQL queries, zero-copy reactive streams (allowing UI widgets to update automatically when DB changes without manual state refresh), and runs background queries in Dart isolates to prevent UI thread stutter during heavy disk I/O.
2. **Clean Repository Pattern**: Following our agreed SOLID standards, widgets will **never** import Drift tables or DAOs directly. They will watch Riverpod providers connected to an abstract `HistoryRepository` that returns clean `Either<Failure, T>` results.

---

## 🏗️ Proposed Architecture & Changes

### 1. Database Schema (`lib/core/data/local/schema/`)
We will define Drift tables matching exactly **Backend Schema §2 (Schema A)**:
- **`TransfersTable`**:
  - `id` (Text, Primary Key)
  - `peerName` (Text)
  - `totalBytes` (Integer)
  - `timestampEpochMs` (Integer)
  - `isSent` (Boolean)
  - `status` (Text: 'completed', 'failed', 'canceled')
  - `durationSeconds` (Integer)
- **`TransferFilesTable`**:
  - `id` (Text, Primary Key)
  - `transferId` (Text, Foreign Key referencing `TransfersTable.id`)
  - `fileName` (Text)
  - `sizeBytes` (Integer)
  - `mimeType` (Text)
  - `storagePath` (Text)
- **`SettingsTable`**:
  - `key` (Text, Primary Key)
  - `value` (Text)

### 2. Drift Database Setup (`lib/core/data/local/app_database.dart`)
- Configure database initialization (`AppDatabase extends _$AppDatabase`) with schema version 1.
- Write DAOs (Data Access Objects) supporting **atomic batch transactions** (e.g., logging a transfer session and its 50 files inside a single database transaction).

### 3. Repository Layer (`lib/features/history/`)
- Create abstract interface `HistoryRepository` (`lib/features/history/domain/history_repository.dart`).
- Implement `LocalHistoryRepository` (`lib/features/history/data/local_history_repository.dart`):
  - `Stream<List<HistoryItem>> watchRecentTransfers()`
  - `Future<Either<Failure, void>> logTransferSession(TransferSession session)`
  - `Future<Either<Failure, void>> clearAllHistory()`

### 4. UI & Provider Integration (`lib/features/home/` & `lib/features/settings/`)
- Replace `mockHistoryProvider` with a real Riverpod `StreamProvider` watching the Drift database.
- Replace `mockDeviceNameProvider` with a persistent provider reading/writing to `SettingsTable`.

---

## 🧪 Verification Plan

### Automated Verification
1. Run `dart run build_runner build` to generate type-safe Drift DAOs and queries.
2. Run `flutter analyze` to guarantee **0 issues found**.
3. Create automated widget/unit test using an in-memory SQLite database (`NativeDatabase.memory()`) to verify that inserting a transfer session emits the correct update down the Riverpod stream.

### Manual / Visual Verification
1. Launch the app (`flutter run`), navigate to Home screen.
2. Complete a simulated transfer flow from Send → File Picker → Radar → Connecting → Progress → Complete.
3. Verify the transfer instantly appears on the Home screen Recent Transfers list.
4. **Force-close and reopen the app** to verify that the transfer record and updated device display name persist permanently.

---

## 🚦 Next Steps
**Please have your developer review this document.** If you require any adjustments to table structures, storage paths, or architectural patterns, let me know. Once approved, reply with **"continue"** or **"approved"** to start building M2!
