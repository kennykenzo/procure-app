import 'package:go_router/go_router.dart';
import 'package:procurement_scanner/screens/home_screen.dart';
import 'package:procurement_scanner/screens/scan_screen.dart';
import 'package:procurement_scanner/screens/manual_entry_screen.dart';
import 'package:procurement_scanner/screens/items_list_screen.dart';
import 'package:procurement_scanner/screens/item_detail_screen.dart';
import 'package:procurement_scanner/screens/locations_screen.dart';

/// Application router configuration
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
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
