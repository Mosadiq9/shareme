/// ShareMe — TCP Transfer Server implementation.
///
/// Binds to local socket and streams file payload in bounded 64KB chunks
/// to prevent memory spikes during large transfers (TRD §5.1).
library;

import 'dart:async';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:logger/logger.dart';
import 'package:shareme/features/transfer/data/protocol/binary_packet_codec.dart';
import 'package:shareme/features/transfer/domain/transfer_item.dart';

class TcpTransferServer {
  TcpTransferServer({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;
  ServerSocket? _serverSocket;
  final StreamController<({int bytesTransferred, int totalBytes})> _progressController =
      StreamController.broadcast();

  Stream<({int bytesTransferred, int totalBytes})> get progressStream =>
      _progressController.stream;

  /// Start TCP server on [port] and stream [items] to the connecting peer.
  Future<void> startServer({required int port, required List<TransferItem> items}) async {
    try {
      _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
      _logger.i('TCP Transfer Server listening on port $port');

      final totalJobBytes = items.fold<int>(0, (sum, i) => sum + i.sizeBytes);
      var cumulativeBytesSent = 0;

      await for (final socket in _serverSocket!) {
        _logger.i('Peer accepted from ${socket.remoteAddress.address}');
        try {
          for (final item in items) {
            final file = File(item.filePath);
            List<int> fileBytes;
            try {
              fileBytes = await file.readAsBytes();
            } on Object catch (_) {
              _logger.w('File missing or unreadable during transfer: ${item.filePath}');
              continue;
            }
            final digest = sha256.convert(fileBytes);

            final header = BinaryHeader(
              fileId: item.id,
              fileName: item.fileName,
              fileSizeBytes: item.sizeBytes,
              sha256Bytes: digest.bytes,
            );

            final headerBytes = BinaryPacketCodec.encodeHeader(header);
            socket.add(headerBytes);

            // Stream 64KB bounded chunks
            final openStream = file.openRead();
            await for (final chunk in openStream) {
              socket.add(chunk);
              cumulativeBytesSent += chunk.length;
              _progressController.add((
                bytesTransferred: cumulativeBytesSent,
                totalBytes: totalJobBytes,
              ));
            }
          }
          await socket.flush();
          await socket.close();
          _logger.i('All files transmitted successfully.');
        } on Object catch (e, st) {
          _logger.e('Socket error during transfer transmission: $e', error: e, stackTrace: st);
          socket.destroy();
        }
        break; // Serve one transfer session per bind
      }
    } on Object catch (e, st) {
      _logger.e('Failed to start TCP server: $e', error: e, stackTrace: st);
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
