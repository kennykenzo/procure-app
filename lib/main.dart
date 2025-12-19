import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:procurement_scanner/router/app_router.dart';
import 'package:procurement_scanner/theme/app_theme.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const ProviderScope(child: ProcurementApp()));
}

class ProcurementApp extends ConsumerStatefulWidget {
  const ProcurementApp({super.key});

  @override
  ConsumerState<ProcurementApp> createState() => _ProcurementAppState();
}

class _ProcurementAppState extends ConsumerState<ProcurementApp> {
  @override
  void initState() {
    super.initState();
    // Remove native splash as soon as Flutter has a frame to show.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(appRouterProvider),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
    );
  }
}
