library;

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shareme/features/transfer/domain/hotspot_state.dart';

class HotspotDataSource {
  HotspotDataSource({Logger? logger}) : _logger = logger ?? Logger() {
    _eventChannel.receiveBroadcastStream().listen((event) {
      if (event is Map) {
        final statusStr = event['status'] as String?;
        final ip = event['ip'] as String?;
        
        var status = HotspotStatus.idle;
        switch (statusStr) {
          case 'creating':
            status = HotspotStatus.creating;
            break;
          case 'connecting':
            status = HotspotStatus.connecting;
            break;
          case 'connected':
            status = HotspotStatus.connected;
            break;
          case 'failed':
            status = HotspotStatus.failed;
            break;
          case 'idle':
            status = HotspotStatus.idle;
            break;
        }
        
        _stateController.add(HotspotState(
          status: status,
          groupOwnerIp: ip,
          errorMessage: status == HotspotStatus.failed ? 'Hotspot operation failed' : null,
        ));
      }
    }, onError: (error) {
      _logger.e('Hotspot event stream error: $error');
      _stateController.add(const HotspotState(status: HotspotStatus.failed, errorMessage: 'Event stream error'));
    });
  }

  static const _methodChannel = MethodChannel('com.mosadiq.shareme/discovery_methods');
  static const _eventChannel = EventChannel('com.mosadiq.shareme/hotspot_events');

  final Logger _logger;
  final StreamController<HotspotState> _stateController = StreamController<HotspotState>.broadcast();

  Stream<HotspotState> watchHotspotState() => _stateController.stream;

  Future<void> createHotspot() async {
    try {
      _stateController.add(const HotspotState(status: HotspotStatus.creating));
      await _methodChannel.invokeMethod<void>('createHotspot');
    } on PlatformException catch (e) {
      _logger.e('Failed to create hotspot: ${e.message}');
      _stateController.add(HotspotState(status: HotspotStatus.failed, errorMessage: e.message));
    }
  }

  Future<void> connectToHotspot(String deviceAddress) async {
    try {
      _stateController.add(const HotspotState(status: HotspotStatus.connecting));
      await _methodChannel.invokeMethod<void>('connectToHotspot', {'deviceAddress': deviceAddress});
    } on PlatformException catch (e) {
      _logger.e('Failed to connect to hotspot: ${e.message}');
      _stateController.add(HotspotState(status: HotspotStatus.failed, errorMessage: e.message));
    }
  }

  Future<void> destroyHotspot() async {
    try {
      await _methodChannel.invokeMethod<void>('destroyHotspot');
    } on PlatformException catch (e) {
      _logger.e('Failed to destroy hotspot: ${e.message}');
    }
  }
}
