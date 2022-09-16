import 'dart:convert';

import 'package:fuse_kyc_service/core/constants.dart';
import 'package:fuse_kyc_service/features/kyc_process/data/models/verified_id_request_callback.dart';
import 'package:fuse_kyc_service/features/kyc_process/data/models/issuance_request_claims.dart';
import 'package:fuse_kyc_service/features/kyc_process/data/models/issuance_request_pin.dart';
import 'package:fuse_kyc_service/features/kyc_process/data/models/issuance_request_request_body.dart';
import 'package:fuse_kyc_service/features/kyc_process/data/models/issuance_request_response_model.dart';
import 'package:fuse_kyc_service/features/kyc_process/data/models/registration.dart';
import 'package:fuse_kyc_service/features/kyc_process/data/repositories/auth_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class VerifiableCredentialRepository {
  final AuthRepository authRepository;

  const VerifiableCredentialRepository({required this.authRepository});

  Future<IssuanceRequestResponseModel> createIssuanceRequest({
    required String firstName,
    required String lastName,
    required IssuanceRequestPin pin,
  }) async {
    final issuanceRequestRequestBody = _createIssuanceRequestRequestBody(
      firstName: firstName,
      lastName: lastName,
      pin: pin,
    );

    final requestBody = jsonEncode(issuanceRequestRequestBody);

    final accessToken = await authRepository.getAccessToken();

    final response = await http.post(
      Uri.parse(createIssuanceRequestURL),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: requestBody,
    );

    if (response.statusCode == 401) {
      await authRepository.refreshAccessToken();
      return createIssuanceRequest(
        firstName: firstName,
        lastName: lastName,
        pin: pin,
      );
    }

    if (response.statusCode == 201) {
      final decodedResponse = jsonDecode(response.body);
      return IssuanceRequestResponseModel.fromJson(decodedResponse);
    } else {
      throw Exception("Failed to create issuance request. ${response.body}");
    }
  }

  IssuanceRequestRequestBody _createIssuanceRequestRequestBody({
    required String firstName,
    required String lastName,
    required IssuanceRequestPin pin,
  }) {
    final state = const Uuid().v1();
    final headers = <String, dynamic>{
      "api-key": "API for ISSUER CALLBACK API",
    };

    final callback = VerifiedIDRequestCallback(
      url: issuanceRequestCallback,
      state: state,
      headers: headers,
    );

    const registration = Registration(clientName: "Fuse KYC Service");

    final claims =
        IssuanceRequestClaims(firstName: firstName, lastName: lastName);

    return IssuanceRequestRequestBody(
      includeQRCode: true,
      callback: callback,
      authority: verifiedIDRequestAuthority,
      registration: registration,
      type: verifiableCredentialType,
      manifest: issuanceRequestManifest,
      pin: pin,
      claims: claims,
    );
  }
}
