/// ShareMe — Transfer Repository Interface.
///
/// Follows Clean Architecture standards for bounded TCP socket transmission
/// and live progress streaming (speed & ETA).
library;

import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:shareme/core/errors/failures.dart';
import 'package:shareme/features/transfer/domain/transfer_item.dart';

abstract interface class TransferRepository {
  /// Live stream of byte progress, calculated transmission speed, and ETA.
  Stream<({int bytesTransferred, int totalBytes, double speedBytesPerSec, int etaSeconds})> watchProgress();

  /// Start TCP server and stream [items] to connecting peer.
  Future<Either<Failure, void>> sendFiles({
    required int port,
    required List<TransferItem> items,
    Map<String, int>? startOffsets,
  });

  /// Connect to sender at [hostIp]:[port] and download files to disk.
  Future<Either<Failure, List<File>>> receiveFiles({
    required String hostIp,
    required int port,
    required int totalExpectedBytes,
    Map<String, int>? initialOffsets,
  });

  /// Stop active socket transmission.
  Future<Either<Failure, void>> stopTransfer();
}
