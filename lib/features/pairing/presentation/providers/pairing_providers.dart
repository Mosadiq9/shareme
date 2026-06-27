/// ShareMe — Pairing Riverpod Providers.
///
/// Exposes cryptographic pairing and band negotiation repositories.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shareme/features/pairing/data/local_pairing_repository.dart';
import 'package:shareme/features/pairing/domain/pairing_repository.dart';

/// Pairing Repository Provider.
final pairingRepositoryProvider = Provider<PairingRepository>((ref) {
  return LocalPairingRepository();
});
