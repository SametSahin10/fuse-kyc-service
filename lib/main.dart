import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuse_kyc_service/features/home/presentation/screens/home_screen.dart';
import 'package:fuse_kyc_service/injection_container.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await initializeDependencyInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Fuse KYC Service',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.raleway().fontFamily,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
