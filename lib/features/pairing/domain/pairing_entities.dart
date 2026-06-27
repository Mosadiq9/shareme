/// ShareMe — Pairing & Band Negotiation Entities.
///
/// Encapsulates cryptographic handshake tokens and frequency preferences.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pairing_entities.freezed.dart';
part 'pairing_entities.g.dart';

@freezed
class PairingRequest with _$PairingRequest {
  const factory PairingRequest({
    required String senderId,
    required String senderName,
    required int itemCount,
    required int totalBytes,
    required String sessionToken,
    required List<String> supportedBands,
  }) = _PairingRequest;

  factory PairingRequest.fromJson(Map<String, dynamic> json) =>
      _$PairingRequestFromJson(json);
}

@freezed
class PairingResponse with _$PairingResponse {
  const factory PairingResponse({
    required String negotiatedBand,
    required int port,
    required bool isVerified,
    required String sessionToken,
  }) = _PairingResponse;

  factory PairingResponse.fromJson(Map<String, dynamic> json) =>
      _$PairingResponseFromJson(json);
}
