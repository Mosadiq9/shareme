/// ShareMe — Discovery Repository Interface.
///
/// Follows Clean Architecture standards: returns functional [Either] types
/// and exposes a reactive stream of nearby discovered peers.
library;

import 'package:fpdart/fpdart.dart';
import 'package:shareme/core/errors/failures.dart';
import 'package:shareme/features/discovery/domain/peer_device.dart';

abstract interface class DiscoveryRepository {
  /// Stream of discovered peers nearby.
  Stream<Either<Failure, List<PeerDevice>>> watchNearbyPeers();

  /// Start scanning for peers, advertising our [deviceName].
  Future<Either<Failure, void>> startDiscovery({required String deviceName});

  /// Stop peer scanning.
  Future<Either<Failure, void>> stopDiscovery();
}
