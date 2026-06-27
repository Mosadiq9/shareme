/// ShareMe — Discovery Riverpod Providers.
///
/// Exposes native discovery data sources, repositories, and live peer streams.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shareme/features/discovery/data/local_discovery_repository.dart';
import 'package:shareme/features/discovery/data/native_discovery_data_source.dart';
import 'package:shareme/features/discovery/domain/discovery_repository.dart';
import 'package:shareme/features/discovery/domain/peer_device.dart';

/// Native Discovery Data Source Provider.
final nativeDiscoveryDataSourceProvider = Provider<NativeDiscoveryDataSource>((ref) {
  return NativeDiscoveryDataSource();
});

/// Discovery Repository Provider.
final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  final dataSource = ref.watch(nativeDiscoveryDataSourceProvider);
  return LocalDiscoveryRepository(dataSource);
});

/// Reactive stream of nearby discovered peers from native platform channels.
final nearbyPeersStreamProvider = StreamProvider<List<PeerDevice>>((ref) {
  final repository = ref.watch(discoveryRepositoryProvider);
  return repository.watchNearbyPeers().map((either) => either.fold(
        (failure) => <PeerDevice>[],
        (peers) => peers,
      ));
});
