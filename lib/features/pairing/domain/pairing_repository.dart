/// ShareMe — Pairing Repository Interface.
///
/// Follows Clean Architecture standards for cryptographic session verification
/// and Wi-Fi Direct band negotiation prior to socket connection.
library;

import 'package:fpdart/fpdart.dart';
import 'package:shareme/core/errors/failures.dart';
import 'package:shareme/features/discovery/domain/peer_device.dart';
import 'package:shareme/features/pairing/domain/pairing_entities.dart';
import 'package:shareme/features/transfer/domain/transfer_item.dart';

abstract interface class PairingRepository {
  /// Initiate cryptographic handshake and negotiate highest available band.
  Future<Either<Failure, PairingResponse>> negotiatePairing({
    required PeerDevice peer,
    required List<TransferItem> items,
    required String senderName,
  });
}
