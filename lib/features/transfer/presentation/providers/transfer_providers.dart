/// ShareMe — Transfer Riverpod Providers.
///
/// Exposes memory-bounded TCP transfer repositories and live progress streams.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shareme/features/transfer/data/local_transfer_repository.dart';
import 'package:shareme/features/transfer/domain/transfer_repository.dart';

/// Transfer Repository Provider.
final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  return LocalTransferRepository();
});
