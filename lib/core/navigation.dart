import 'package:flutter/material.dart';
import 'package:fuse_kyc_service/features/kyc_process/presentation/screens/initiate_vc_issuance_screen.dart';
import 'package:fuse_kyc_service/features/kyc_process/presentation/screens/kyc_form_screen.dart';

void pushKYCFormScreen(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => const KycFormScreen(),
    ),
  );
}

void pushInitiateVCIssuanceScreen({
  required BuildContext context,
  required String rawQRCode,
  required String pin,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) {
        return InitiateVCIssuanceScreen(rawQRCode: rawQRCode, pin: pin);
      },
    ),
  );
}
