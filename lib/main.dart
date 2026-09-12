import 'package:flutter/material.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const SmogRiskApp());
}

class SmogRiskApp extends StatelessWidget {
  const SmogRiskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smog Risk Prediction System',
      home: const LoginPage(),
    );
  }
}