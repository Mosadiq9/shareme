/// ShareMe — Binary Packet Codec & Wire Format Contract.
///
/// Implements TRD §5.2 header specification for raw TCP socket transmission:
/// `[UUID 36B UTF8] [FileNameLen 2B Uint16] [FileName UTF8] [FileSizeBytes 8B Uint64] [SHA256 32B Raw]`
library;

import 'dart:convert';
import 'dart:typed_data';

class BinaryHeader {
  const BinaryHeader({
    required this.fileId,
    required this.fileName,
    required this.fileSizeBytes,
    required this.sha256Bytes,
  });

  /// Unique UUID string (e.g. 36 chars).
  final String fileId;

  /// Relative file name.
  final String fileName;

  /// Total file size in bytes.
  final int fileSizeBytes;

  /// 32-byte raw SHA-256 hash digest.
  final List<int> sha256Bytes;
}

class BinaryPacketCodec {
  static const int _uuidByteLength = 36;
  static const int _sha256ByteLength = 32;

  /// Encode a [BinaryHeader] into a packed byte buffer ready to prepend to socket stream.
  static Uint8List encodeHeader(BinaryHeader header) {
    final nameBytes = utf8.encode(header.fileName);
    final nameLen = nameBytes.length;
    if (nameLen > 65535) {
      throw ArgumentError('File name exceeds maximum 65535 bytes');
    }

    // Padded or truncated UUID string to 36 bytes
    final idBytes = utf8.encode(header.fileId.padRight(_uuidByteLength).substring(0, _uuidByteLength));

    // Ensure SHA256 is 32 bytes
    var hashBytes = header.sha256Bytes;
    if (hashBytes.length != _sha256ByteLength) {
      hashBytes = List<int>.filled(_sha256ByteLength, 0);
    }

    final totalHeaderLen = _uuidByteLength + 2 + nameLen + 8 + _sha256ByteLength;
    final buffer = Uint8List(totalHeaderLen);
    final byteData = ByteData.view(buffer.buffer);

    var offset = 0;
    // 1. UUID (36 bytes)
    buffer.setRange(offset, offset + _uuidByteLength, idBytes);
    offset += _uuidByteLength;

    // 2. FileNameLength (2 bytes, Big Endian)
    byteData.setUint16(offset, nameLen);
    offset += 2;

    // 3. FileName (nameLen bytes)
    buffer.setRange(offset, offset + nameLen, nameBytes);
    offset += nameLen;

    // 4. FileSize (8 bytes, Big Endian)
    byteData.setUint64(offset, header.fileSizeBytes);
    offset += 8;

    // 5. SHA256 (32 bytes)
    buffer.setRange(offset, offset + _sha256ByteLength, hashBytes);

    return buffer;
  }

  /// Decode a packed byte buffer back into a [BinaryHeader] and return payload offset.
  static ({BinaryHeader header, int payloadOffset})? decodeHeader(Uint8List buffer) {
    if (buffer.length < _uuidByteLength + 2 + 8 + _sha256ByteLength) {
      return null; // Not enough data for minimal header
    }

    final byteData = ByteData.view(buffer.buffer, buffer.offsetInBytes, buffer.length);
    var offset = 0;

    // 1. UUID
    final idBytes = buffer.sublist(offset, offset + _uuidByteLength);
    final fileId = utf8.decode(idBytes).trim();
    offset += _uuidByteLength;

    // 2. FileNameLength
    final nameLen = byteData.getUint16(offset);
    offset += 2;

    if (buffer.length < offset + nameLen + 8 + _sha256ByteLength) {
      return null; // Buffer does not contain complete header yet
    }

    // 3. FileName
    final nameBytes = buffer.sublist(offset, offset + nameLen);
    final fileName = utf8.decode(nameBytes);
    offset += nameLen;

    // 4. FileSize
    final fileSizeBytes = byteData.getUint64(offset);
    offset += 8;

    // 5. SHA256
    final sha256Bytes = buffer.sublist(offset, offset + _sha256ByteLength);
    offset += _sha256ByteLength;

    final header = BinaryHeader(
      fileId: fileId,
      fileName: fileName,
      fileSizeBytes: fileSizeBytes,
      sha256Bytes: sha256Bytes,
    );

    return (header: header, payloadOffset: offset);
  }
}
