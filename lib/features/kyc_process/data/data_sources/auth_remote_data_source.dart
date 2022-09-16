import 'dart:convert';

import 'package:fuse_kyc_service/features/kyc_process/data/models/microsoft_oauth_access_token_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  Future<String> getAccessToken() async {
    final url = Uri.parse(
      "https://us-central1-fuse-kyc-demo.cloudfunctions.net/getAccessToken",
    );
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to get access token.");
    }

    final decodedResponseBody = jsonDecode(response.body);
    final accessTokenModel =
        MicrosoftOAuthAccessTokenModel.fromJson(decodedResponseBody);

    return accessTokenModel.accessToken;
  }
}
