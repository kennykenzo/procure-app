import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:procurement_scanner/theme/app_theme.dart';
import 'package:procurement_scanner/widgets/floating_bottom_nav_bar.dart';
import 'package:procurement_scanner/screens/tabs/dashboard_tab.dart';
import 'package:procurement_scanner/screens/tabs/items_tab.dart';
import 'package:procurement_scanner/screens/tabs/locations_tab.dart';

/// Home screen with dashboard and tab navigation
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            const DashboardTab(),
            const ItemsTab(),
            const LocationsTab(),
          ],
        ),
      ),
      bottomNavigationBar: FloatingBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
