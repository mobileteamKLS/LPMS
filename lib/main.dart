import 'package:flutter/material.dart';
import 'package:lpms/screens/ExportDashboard.dart';
import 'package:lpms/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme:AppTheme.lightTheme,
      home: const ExportsDashboardScreen(),
    );
  }
}


