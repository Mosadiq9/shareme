/// ShareMe — TCP Transfer Server implementation.
///
/// Binds to local socket and streams file payload in bounded 64KB chunks
/// to prevent memory spikes during large transfers (TRD §5.1).
library;

import 'dart:async';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:logger/logger.dart';
import 'package:shareme/core/constants/enums.dart';
import 'package:shareme/features/transfer/data/performance/buffer_scaling_strategy.dart';
import 'package:shareme/features/transfer/data/protocol/binary_packet_codec.dart';
import 'package:shareme/features/transfer/domain/transfer_item.dart';

class TcpTransferServer {
  TcpTransferServer({BufferScalingStrategy? bufferStrategy, Logger? logger})
      : _bufferStrategy = bufferStrategy ?? BufferScalingStrategy(),
        _logger = logger ?? Logger();

  final BufferScalingStrategy _bufferStrategy;
  final Logger _logger;
  ServerSocket? _serverSocket;
  final StreamController<({int bytesTransferred, int totalBytes, String? currentFileName})> _progressController =
      StreamController.broadcast();

  Stream<({int bytesTransferred, int totalBytes, String? currentFileName})> get progressStream =>
      _progressController.stream;

  /// Start TCP server on [port] and stream [items] to the connecting peer.
  Future<void> startServer({
    required int port,
    required List<TransferItem> items,
    Map<String, int>? startOffsets,
    WifiBand band = WifiBand.ghz5,
  }) async {
    try {
      final bufferSize = _bufferStrategy.getInitialBufferSize(band);
      _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
      _logger.i('🐞 [DEBUG MODE] TCP Transfer Server listening on port $port (buffer: $bufferSize B)');

      final totalJobBytes = items.fold<int>(0, (sum, i) => sum + i.sizeBytes);
      var cumulativeBytesSent = 0;

      await for (final socket in _serverSocket!) {
        _logger.i('🐞 [DEBUG MODE] Peer accepted from ${socket.remoteAddress.address}');
        try {
          for (final item in items) {
            final file = File(item.filePath);
            if (!await file.exists()) {
              _logger.w('🐞 [DEBUG MODE] File missing or unreadable during transfer: ${item.filePath}');
              continue;
            }
            Digest digest;
            try {
              digest = await sha256.bind(file.openRead()).first;
            } on Object catch (e) {
              _logger.w('🐞 [DEBUG MODE] Error reading file for sha256: $e');
              continue;
            }

            final header = BinaryHeader(
              fileId: item.id,
              fileName: item.fileName,
              fileSizeBytes: item.sizeBytes,
              sha256Bytes: digest.bytes,
            );

            final headerBytes = BinaryPacketCodec.encodeHeader(header);
            socket.add(headerBytes);

            final startOffset = startOffsets?[item.id] ?? 0;
            if (startOffset > 0) {
              _logger.i('🐞 [DEBUG MODE] Seeking file ${item.fileName} to resume offset $startOffset');
              cumulativeBytesSent += startOffset;
            }

            // Stream 64KB bounded chunks starting from startOffset
            final openStream = file.openRead(startOffset);
            await for (final chunk in openStream) {
              socket.add(chunk);
              cumulativeBytesSent += chunk.length;
              _progressController.add((
                bytesTransferred: cumulativeBytesSent,
                totalBytes: totalJobBytes,
                currentFileName: item.name,
              ));
            }
          }
          await socket.flush();
          await socket.close();
          _logger.i('🐞 [DEBUG MODE] All files transmitted successfully.');
        } on Object catch (e, st) {
          _logger.e('🐞 [DEBUG MODE] Socket error during transfer transmission: $e', error: e, stackTrace: st);
          socket.destroy();
        }
        break; // Serve one transfer session per bind
      }
    } on Object catch (e, st) {
      _logger.e('🐞 [DEBUG MODE] Failed to start TCP server: $e', error: e, stackTrace: st);
      rethrow;
    } finally {
      await stopServer();
    }
  }

  Future<void> stopServer() async {
    await _serverSocket?.close();
    _serverSocket = null;
  }
}
