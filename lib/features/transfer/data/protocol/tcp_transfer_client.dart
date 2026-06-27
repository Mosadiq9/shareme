/// ShareMe — TCP Transfer Client implementation.
///
/// Connects to sender's socket, decodes binary packet headers, and streams
/// payload chunks to disk with on-the-fly SHA-256 verification (TRD §5.2).
library;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shareme/core/constants/enums.dart';
import 'package:shareme/features/transfer/data/performance/buffer_scaling_strategy.dart';
import 'package:shareme/features/transfer/data/protocol/binary_packet_codec.dart';

class TcpTransferClient {
  TcpTransferClient({BufferScalingStrategy? bufferStrategy, Logger? logger})
      : _bufferStrategy = bufferStrategy ?? BufferScalingStrategy(),
        _logger = logger ?? Logger();

  final BufferScalingStrategy _bufferStrategy;
  final Logger _logger;
  Socket? _socket;
  final StreamController<({int bytesTransferred, int totalBytes})> _progressController =
      StreamController.broadcast();

  Stream<({int bytesTransferred, int totalBytes})> get progressStream =>
      _progressController.stream;

  /// Connect to sender at [hostIp]:[port] and receive incoming file stream.
  Future<List<File>> receiveFiles({
    required String hostIp,
    required int port,
    Map<String, int>? initialOffsets,
    WifiBand band = WifiBand.ghz5,
  }) async {
    final downloadedFiles = <File>[];
    IOSink? currentSink;
    try {
      final bufferSize = _bufferStrategy.getInitialBufferSize(band);
      _socket = await Socket.connect(hostIp, port, timeout: const Duration(seconds: 5));
      _logger.i('Connected to TCP sender at $hostIp:$port (buffer strategy: $bufferSize B)');

      final downloadDir = await getTemporaryDirectory();
      var buffer = Uint8List(0);

      BinaryHeader? currentHeader;
      File? currentFile;
      var currentFileBytesReceived = 0;
      var cumulativeBytesReceived = 0;

      final completer = Completer<List<File>>();

      _socket!.listen(
        (Uint8List data) async {
          // Append data to buffer
          final builder = BytesBuilder(copy: false)..add(buffer)..add(data);
          buffer = builder.toBytes();

          // Process buffer loop
          while (buffer.isNotEmpty) {
            final header = currentHeader;
            final sink = currentSink;
            final file = currentFile;
            if (header == null || sink == null || file == null) {
              final decodeResult = BinaryPacketCodec.decodeHeader(buffer);
              if (decodeResult == null) {
                break; // Need more bytes for header
              }
              currentHeader = decodeResult.header;
              final payloadOffset = decodeResult.payloadOffset;
              buffer = buffer.sublist(payloadOffset);

              final h = currentHeader!;
              final filePath = '${downloadDir.path}/${h.fileName}';
              currentFile = File(filePath);

              final existingOffset = initialOffsets?[h.fileId] ?? 0;
              if (existingOffset > 0) {
                currentSink = currentFile!.openWrite(mode: FileMode.append);
                currentFileBytesReceived = existingOffset;
                cumulativeBytesReceived += existingOffset;
                _logger.i('Resuming receive for file: ${h.fileName} from offset $existingOffset');
              } else {
                currentSink = currentFile!.openWrite();
                currentFileBytesReceived = 0;
                _logger.i('Starting receive for file: ${h.fileName} (${h.fileSizeBytes} B)');
              }
            } else {
              final bytesNeeded = header.fileSizeBytes - currentFileBytesReceived;
              if (buffer.length <= bytesNeeded) {
                sink.add(buffer);
                currentFileBytesReceived += buffer.length;
                cumulativeBytesReceived += buffer.length;
                _progressController.add((
                  bytesTransferred: cumulativeBytesReceived,
                  totalBytes: header.fileSizeBytes, // Single/multi file tracking
                ));
                buffer = Uint8List(0);
              } else {
                final chunk = buffer.sublist(0, bytesNeeded);
                sink.add(chunk);
                currentFileBytesReceived += chunk.length;
                cumulativeBytesReceived += chunk.length;
                buffer = buffer.sublist(bytesNeeded);
              }

              if (currentFileBytesReceived >= header.fileSizeBytes) {
                await sink.flush();
                await sink.close();

                // Verify checksum
                final fileBytes = await file.readAsBytes();
                final calculatedDigest = sha256.convert(fileBytes);
                var isCorrupted = false;
                for (var i = 0; i < 32; i++) {
                  if (calculatedDigest.bytes[i] != header.sha256Bytes[i]) {
                    isCorrupted = true;
                    break;
                  }
                }

                if (isCorrupted) {
                  _logger.e('Checksum mismatch! Quarantining file: ${header.fileName}');
                  try {
                    await file.delete();
                  } on Object catch (_) {}
                  throw Exception('Checksum verification failed for ${header.fileName}');
                } else {
                  _logger.i('Verified & saved: ${header.fileName}');
                  downloadedFiles.add(file);
                }

                currentHeader = null;
                currentSink = null;
                currentFile = null;
              }
            }
          }
        },
        onDone: () {
          _logger.i('Socket connection closed by sender.');
          if (!completer.isCompleted) completer.complete(downloadedFiles);
        },
        onError: (Object e) {
          _logger.e('Socket client error: $e');
          if (!completer.isCompleted) completer.completeError(e);
        },
      );

      return await completer.future;
    } on Object catch (e, st) {
      _logger.e('Failed to receive files over TCP: $e', error: e, stackTrace: st);
      rethrow;
    } finally {
      await currentSink?.close();
      await _socket?.close();
      _socket = null;
    }
  }

  Future<void> disconnect() async {
    await _socket?.close();
    _socket = null;
  }
}
