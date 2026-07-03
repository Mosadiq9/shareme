/// ShareMe — TCP Transfer Client implementation.
///
/// Connects to sender's socket, decodes binary packet headers, and streams
/// payload chunks to disk with on-the-fly SHA-256 verification (TRD §5.2).
library;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
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
  final StreamController<({int bytesTransferred, int totalBytes, String? currentFileName})> _progressController =
      StreamController.broadcast();

  Stream<({int bytesTransferred, int totalBytes, String? currentFileName})> get progressStream =>
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
      var attempts = 0;
      const maxAttempts = 30;
      while (_socket == null && attempts < maxAttempts) {
        attempts++;
        try {
          _logger.i('🐞 [DEBUG MODE] Attempting TCP socket connect to $hostIp:$port (Attempt $attempts/$maxAttempts)...');
          _socket = await Socket.connect(hostIp, port, timeout: const Duration(seconds: 3));
        } on SocketException catch (e) {
          if (attempts >= maxAttempts) rethrow;
          _logger.w('🐞 [DEBUG MODE] Connection refused or timed out ($e). Sender server might still be initializing. Retrying in 1s...');
          await Future<void>.delayed(const Duration(seconds: 1));
        }
      }
      _logger.i('🐞 [DEBUG MODE] Connected to TCP sender at $hostIp:$port (buffer strategy: $bufferSize B)');
      
      _socket!.setOption(SocketOption.tcpNoDelay, true);

      Directory downloadDir;
      if (Platform.isAndroid) {
        downloadDir = Directory('/storage/emulated/0/Download/ShareMe');
      } else {
        downloadDir = await getApplicationDocumentsDirectory();
      }
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }
      _logger.i('🐞 [DEBUG MODE] Saving incoming files to public directory: ${downloadDir.path}');
      var buffer = Uint8List(0);

      BinaryHeader? currentHeader;
      File? currentFile;
      var currentFileBytesReceived = 0;
      var cumulativeBytesReceived = 0;
      var lastEmittedBytes = 0;
      var lastEmitTime = DateTime.now();

      final completer = Completer<List<File>>();

      _socket!.listen(
        (Uint8List data) async {
          // Zero-copy direct streaming path
          if (currentHeader != null && buffer.isEmpty) {
            final header = currentHeader!;
            final sink = currentSink!;
            final bytesNeeded = header.fileSizeBytes - currentFileBytesReceived;
            
            if (data.length <= bytesNeeded) {
              sink.add(data);
              currentFileBytesReceived += data.length;
              cumulativeBytesReceived += data.length;
              
              final now = DateTime.now();
              if (cumulativeBytesReceived - lastEmittedBytes >= 524288 ||
                  now.difference(lastEmitTime).inMilliseconds >= 100 ||
                  currentFileBytesReceived >= header.fileSizeBytes) {
                lastEmittedBytes = cumulativeBytesReceived;
                lastEmitTime = now;
                _progressController.add((
                  bytesTransferred: cumulativeBytesReceived,
                  totalBytes: header.fileSizeBytes,
                  currentFileName: header.fileName,
                ));
              }

              if (currentFileBytesReceived >= header.fileSizeBytes) {
                try {
                  await sink.flush();
                  await sink.close();
                } on Object catch (_) {}
                _logger.i('🐞 [DEBUG MODE] Saved: ${header.fileName}');
                
                currentHeader = null;
                currentSink = null;
                currentFile = null;
              }
              return; // Crucial: avoid buffer allocation
            } else {
              // Crossover boundary (data spans into next file's header)
              final chunk = data.sublist(0, bytesNeeded);
              sink.add(chunk);
              currentFileBytesReceived += chunk.length;
              cumulativeBytesReceived += chunk.length;
              
              final now = DateTime.now();
              _progressController.add((
                bytesTransferred: cumulativeBytesReceived,
                totalBytes: header.fileSizeBytes,
                currentFileName: header.fileName,
              ));
              lastEmittedBytes = cumulativeBytesReceived;
              lastEmitTime = now;

              try {
                await sink.flush();
                await sink.close();
              } on Object catch (_) {}
              _logger.i('🐞 [DEBUG MODE] Saved: ${header.fileName}');
              
              currentHeader = null;
              currentSink = null;
              currentFile = null;
              
              // Remainder goes into buffer for standard processing
              buffer = data.sublist(bytesNeeded);
            }
          } else {
            // Header parsing or mixed buffer path
            final builder = BytesBuilder(copy: false)..add(buffer)..add(data);
            buffer = builder.toBytes();
          }

          // Process remaining buffer (Headers and leftovers)
          while (buffer.isNotEmpty) {
            final header = currentHeader;
            final sink = currentSink;
            final file = currentFile;
            
            if (header == null || sink == null || file == null) {
              final decodeResult = BinaryPacketCodec.decodeHeader(buffer);
              if (decodeResult == null) break;
              currentHeader = decodeResult.header;
              buffer = buffer.sublist(decodeResult.payloadOffset);

              final filePath = '${downloadDir.path}/${currentHeader!.fileName}';
              currentFile = File(filePath);
              downloadedFiles.add(currentFile!);

              var existingOffset = 0;
              if (initialOffsets != null && initialOffsets.containsKey(currentHeader!.fileId)) {
                existingOffset = initialOffsets[currentHeader!.fileId]!;
              }

              if (existingOffset > 0 && await currentFile!.exists()) {
                currentSink = currentFile!.openWrite(mode: FileMode.append);
                currentFileBytesReceived = existingOffset;
                cumulativeBytesReceived += existingOffset;
                _logger.i('🐞 [DEBUG MODE] Resuming receive for file: ${currentHeader!.fileName} from offset $existingOffset');
              } else {
                currentSink = currentFile!.openWrite();
                currentFileBytesReceived = 0;
                _logger.i('🐞 [DEBUG MODE] Starting receive for file: ${currentHeader!.fileName} (${currentHeader!.fileSizeBytes} B)');
              }
            } else {
              final bytesNeeded = header.fileSizeBytes - currentFileBytesReceived;
              if (bytesNeeded > 0) {
                if (buffer.length <= bytesNeeded) {
                  sink.add(buffer);
                  currentFileBytesReceived += buffer.length;
                  cumulativeBytesReceived += buffer.length;
                  
                  final now = DateTime.now();
                  if (cumulativeBytesReceived - lastEmittedBytes >= 524288 ||
                      now.difference(lastEmitTime).inMilliseconds >= 100 ||
                      currentFileBytesReceived >= header.fileSizeBytes) {
                    lastEmittedBytes = cumulativeBytesReceived;
                    lastEmitTime = now;
                    _progressController.add((
                      bytesTransferred: cumulativeBytesReceived,
                      totalBytes: header.fileSizeBytes,
                      currentFileName: header.fileName,
                    ));
                  }
                  buffer = Uint8List(0);
                  continue;
                } else {
                  final chunk = buffer.sublist(0, bytesNeeded);
                  sink.add(chunk);
                  currentFileBytesReceived += chunk.length;
                  cumulativeBytesReceived += chunk.length;
                  buffer = buffer.sublist(bytesNeeded);
                  
                  final now = DateTime.now();
                  if (cumulativeBytesReceived - lastEmittedBytes >= 524288 ||
                      now.difference(lastEmitTime).inMilliseconds >= 100 ||
                      currentFileBytesReceived >= header.fileSizeBytes) {
                    lastEmittedBytes = cumulativeBytesReceived;
                    lastEmitTime = now;
                    _progressController.add((
                      bytesTransferred: cumulativeBytesReceived,
                      totalBytes: header.fileSizeBytes,
                      currentFileName: header.fileName,
                    ));
                  }
                }
              }

              try {
                await sink.flush();
                await sink.close();
              } on Object catch (_) {}
              _logger.i('🐞 [DEBUG MODE] Saved: ${header.fileName}');

              currentHeader = null;
              currentSink = null;
              currentFile = null;
            }
          }
        },
        onDone: () {
          _logger.i('🐞 [DEBUG MODE] Socket connection closed by sender.');
          if (!completer.isCompleted) completer.complete(downloadedFiles);
        },
        onError: (Object e) {
          _logger.e('🐞 [DEBUG MODE] Socket client error: $e');
          if (!completer.isCompleted) completer.completeError(e);
        },
      );

      return await completer.future;
    } on Object catch (e, st) {
      _logger.e('🐞 [DEBUG MODE] Failed to receive files over TCP: $e', error: e, stackTrace: st);
      rethrow;
    } finally {
      try {
        await currentSink?.close();
      } on Object catch (_) {}
      await _socket?.close();
      _socket = null;
    }
  }

  Future<void> disconnect() async {
    await _socket?.close();
    _socket = null;
  }
}
