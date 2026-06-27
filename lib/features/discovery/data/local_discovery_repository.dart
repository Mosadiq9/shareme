/// ShareMe — Local Discovery Repository Implementation.
///
/// Maps raw native platform event maps into verified domain entities.
library;

import 'package:fpdart/fpdart.dart';
import 'package:shareme/core/errors/failures.dart';
import 'package:shareme/features/discovery/data/native_discovery_data_source.dart';
import 'package:shareme/features/discovery/domain/discovery_repository.dart';
import 'package:shareme/features/discovery/domain/peer_device.dart';

class LocalDiscoveryRepository implements DiscoveryRepository {
  LocalDiscoveryRepository(this._dataSource);

  final NativeDiscoveryDataSource _dataSource;

  @override
  Stream<Either<Failure, List<PeerDevice>>> watchNearbyPeers() {
    return _dataSource.watchDiscoveredPeers().map((maps) {
      try {
        final peers = maps.map(PeerDevice.fromJson).toList();
        return Right<Failure, List<PeerDevice>>(peers);
      } on Object catch (e, st) {
        return Left<Failure, List<PeerDevice>>(
          DiscoveryFailure(message: 'Failed to parse discovered peer data: $e', stackTrace: st),
        );
      }
    }).handleError((Object error, StackTrace st) {
      return Left<Failure, List<PeerDevice>>(
        DiscoveryFailure(message: 'Native stream error: $error', stackTrace: st),
      );
    });
  }

  @override
  Future<Either<Failure, void>> startDiscovery({required String deviceName}) async {
    try {
      await _dataSource.startDiscovery(deviceName: deviceName);
      return const Right(null);
    } on Object catch (e, st) {
      return Left(DiscoveryFailure(message: 'Could not start discovery: $e', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, void>> stopDiscovery() async {
    try {
      await _dataSource.stopDiscovery();
      return const Right(null);
    } on Object catch (e, st) {
      return Left(DiscoveryFailure(message: 'Could not stop discovery: $e', stackTrace: st));
    }
  }
}
