import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:procurement_scanner/router/app_router.dart';
import 'package:procurement_scanner/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: ProcurementApp()));
}

class ProcurementApp extends StatelessWidget {
  const ProcurementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
    );
  }
}
