/// ShareMe — Native Discovery Data Source.
///
/// Bridges native Android (WifiP2p/mDNS) and iOS (Bonjour Network Framework)
/// discovery streams to Flutter via MethodChannel and EventChannel.
library;

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class NativeDiscoveryDataSource {
  NativeDiscoveryDataSource({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;

  static const MethodChannel _methodChannel =
      MethodChannel('com.mosadiq.shareme/discovery_methods');
  static const EventChannel _eventChannel =
      EventChannel('com.mosadiq.shareme/discovery_events');

  /// Start scanning for nearby peers via native Wi-Fi Direct and mDNS.
  Future<void> startDiscovery({
    required String deviceName,
    required String uuid,
  }) async {
    try {
      _logger.i('Starting native discovery bridge for: $deviceName (UUID: $uuid)');
      await _methodChannel.invokeMethod<void>('startDiscovery', {
        'deviceName': deviceName,
        'uuid': uuid,
      });
    } on PlatformException catch (e, st) {
      _logger.e('Failed to start discovery method channel: $e', error: e, stackTrace: st);
      throw Exception('Native discovery failed to start: ${e.message}');
    }
  }

  /// Stop native peer scanning.
  Future<void> stopDiscovery() async {
    try {
      _logger.i('Stopping native discovery bridge.');
      await _methodChannel.invokeMethod<void>('stopDiscovery');
    } on PlatformException catch (e, st) {
      _logger.w('Failed to stop discovery cleanly: $e', error: e, stackTrace: st);
    }
  }

  /// Stream of discovered peers emitted by the platform native code.
  Stream<List<Map<String, dynamic>>> watchDiscoveredPeers() {
    return _eventChannel.receiveBroadcastStream().map((dynamic event) {
      if (event is List) {
        return event
            .whereType<Map<dynamic, dynamic>>()
            .map(Map<String, dynamic>.from)
            .toList();
      }
      return <Map<String, dynamic>>[];
    });
  }
}
