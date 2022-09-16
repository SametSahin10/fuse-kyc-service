import 'package:flutter/material.dart';
import 'package:fuse_kyc_service/core/navigation.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(24),
      ),
      child: const Text(
        "Sign up",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
      onPressed: () => pushKYCFormScreen(context),
    );
  }
}
