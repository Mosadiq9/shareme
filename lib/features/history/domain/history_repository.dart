/// ShareMe — History Repository Interface.
///
/// Follows Clean Architecture standards: returns functional [Either] types
/// and streams reactive updates from local storage.
library;

import 'package:fpdart/fpdart.dart';
import 'package:shareme/core/errors/failures.dart';
import 'package:shareme/features/home/domain/history_item.dart';
import 'package:shareme/features/transfer/domain/transfer_session.dart';

abstract interface class HistoryRepository {
  /// Watch a reactive stream of recent transfer history items.
  Stream<Either<Failure, List<HistoryItem>>> watchRecentTransfers();

  /// Log a completed or failed transfer session into persistence.
  Future<Either<Failure, void>> logTransferSession(TransferSession session);

  /// Delete all transfer history records.
  Future<Either<Failure, void>> clearHistory();
}
