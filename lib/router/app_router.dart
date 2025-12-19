import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:procurement_scanner/providers/auth_provider.dart';
import 'package:procurement_scanner/screens/home_screen.dart';
import 'package:procurement_scanner/screens/login_screen.dart';
import 'package:procurement_scanner/screens/scan_screen.dart';
import 'package:procurement_scanner/screens/manual_entry_screen.dart';
import 'package:procurement_scanner/screens/items_list_screen.dart';
import 'package:procurement_scanner/screens/item_detail_screen.dart';
import 'package:procurement_scanner/screens/locations_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.onDispose(refresh.dispose);

  // Re-run redirect logic when auth changes.
  ref.listen<AuthState>(authStateProvider, (_, __) => refresh.value++);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: refresh,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final authStatus = authState.status;
      final isLoggedIn = authStatus == AuthStateEnum.loggedIn;
      final isWaiting = authStatus == AuthStateEnum.waiting;
      final isLoggingIn = state.matchedLocation == '/login';

      // If still waiting for session check, don't redirect yet
      if (isWaiting) {
        return null;
      }

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/scan',
        name: 'scan',
        builder: (context, state) => const ScanScreen(),
      ),
      GoRoute(
        path: '/manual-entry',
        name: 'manual-entry',
        builder: (context, state) => const ManualEntryScreen(),
      ),
      GoRoute(
        path: '/items',
        name: 'items',
        builder: (context, state) => const ItemsListScreen(),
      ),
      GoRoute(
        path: '/items/:id',
        name: 'item-detail',
        builder: (context, state) {
          final itemId = state.pathParameters['id']!;
          return ItemDetailScreen(itemId: itemId);
        },
      ),
      GoRoute(
        path: '/locations',
        name: 'locations',
        builder: (context, state) => const LocationsScreen(),
      ),
    ],
  );
});
