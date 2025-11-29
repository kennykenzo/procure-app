import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:procurement_scanner/models/item.dart';
import 'package:procurement_scanner/providers/items_provider.dart';
import 'package:procurement_scanner/providers/transactions_provider.dart';
import 'package:procurement_scanner/providers/locations_provider.dart';
import 'package:procurement_scanner/theme/app_theme.dart';
import 'package:procurement_scanner/widgets/floating_bottom_nav_bar.dart';
import 'package:procurement_scanner/widgets/item_card.dart';
import 'package:procurement_scanner/widgets/scan_button.dart';
import 'package:procurement_scanner/widgets/stat_card.dart';
import 'package:procurement_scanner/widgets/transaction_history.dart';

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
    final theme = Theme.of(context);
    final tabTitles = ['Dashboard', 'Items', 'Locations'];
    final tabSubtitles = [
      'Procurement Scanner',
      'Inventory Management',
      'Location Overview',
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tabSubtitles[_selectedIndex],
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -1.0,
                fontSize: 32,
                color: AppTheme.primaryBlack,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              tabTitles[_selectedIndex],
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.darkGray,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        elevation: 0,
        toolbarHeight: 88,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppTheme.lightGray,
        actions: _selectedIndex == 1
            ? [
                IconButton(
                  icon: const Icon(Icons.add_rounded),
                  onPressed: () => context.push('/manual-entry'),
                  tooltip: 'Add Item',
                ),
              ]
            : _selectedIndex == 2
            ? [
                IconButton(
                  icon: const Icon(Icons.add_rounded),
                  onPressed: () {
                    // TODO: Add location dialog
                  },
                  tooltip: 'Add Location',
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            const _DashboardTab(),
            const _ItemsTab(),
            const _LocationsTab(),
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

/// Dashboard tab content
class _DashboardTab extends ConsumerWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final itemsAsync = ref.watch(itemsProvider);
    final transactionsAsync = ref.watch(transactionsProvider);

    return itemsAsync.when(
      data: (items) {
        return transactionsAsync.when(
          data: (transactions) {
            final recentTransactions = transactions.take(5).toList();
            final totalItems = items.length;
            final totalQuantity = items.fold<int>(
              0,
              (sum, item) => sum + item.quantity,
            );
            final recentActivity = transactions.length;

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(itemsProvider);
                ref.invalidate(transactionsProvider);
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Hero Quick Actions Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                      child: ScanButton(
                        onTap: () => context.push('/scan'),
                        label: 'Scan Item',
                        isLarge: true,
                      ),
                    ),
                  ),

                  // Stats Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Overview',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.0,
                              fontSize: 28,
                              color: AppTheme.primaryBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // Stats Grid
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.3,
                          ),
                      delegate: SliverChildListDelegate([
                        StatCard(
                          title: 'Total Items',
                          value: totalItems.toString(),
                          icon: Icons.inventory_2_rounded,
                          iconColor: const Color(0xFF007AFF),
                        ),
                        StatCard(
                          title: 'Total Quantity',
                          value: totalQuantity.toString(),
                          icon: Icons.numbers_rounded,
                          iconColor: const Color(0xFF34C759),
                        ),
                        StatCard(
                          title: 'Locations',
                          value: '5',
                          icon: Icons.location_on_rounded,
                          iconColor: const Color(0xFFFF9500),
                        ),
                        StatCard(
                          title: 'Recent Activity',
                          value: recentActivity.toString(),
                          icon: Icons.history_rounded,
                          iconColor: const Color(0xFFAF52DE),
                        ),
                      ]),
                    ),
                  ),

                  // Recent Transactions Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 44, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Recent Activity',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.0,
                              fontSize: 28,
                              color: AppTheme.primaryBlack,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push('/transactions'),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'View All',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Transactions List
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: TransactionHistory(
                        transactions: recentTransactions,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 88)),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

/// Items tab content
class _ItemsTab extends ConsumerStatefulWidget {
  const _ItemsTab();

  @override
  ConsumerState<_ItemsTab> createState() => _ItemsTabState();
}

class _ItemsTabState extends ConsumerState<_ItemsTab> {
  final _searchController = TextEditingController();
  String? _selectedLocationId;
  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Item> _getFilteredItems(List<Item> items) {
    final searchQuery = _searchController.text;
    var filteredItems = items;

    if (searchQuery.isNotEmpty) {
      final lowerQuery = searchQuery.toLowerCase();
      filteredItems = filteredItems.where((item) {
        return item.name.toLowerCase().contains(lowerQuery) ||
            (item.barcode?.toLowerCase().contains(lowerQuery) ?? false) ||
            (item.category?.toLowerCase().contains(lowerQuery) ?? false) ||
            item.materialCode.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    if (_selectedLocationId != null) {
      filteredItems = filteredItems
          .where((item) => item.currentLocation == _selectedLocationId)
          .toList();
    }

    if (_selectedCategory != null) {
      filteredItems = filteredItems
          .where((item) => item.category == _selectedCategory)
          .toList();
    }

    return filteredItems;
  }

  List<String> _getCategories(List<Item> items) {
    final categories = items
        .where((item) => item.category != null)
        .map((item) => item.category!)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    final locationsAsync = ref.watch(locationsProvider);
    final itemsAsync = ref.watch(itemsProvider);
    final theme = Theme.of(context);

    return locationsAsync.when(
      data: (locations) {
        return itemsAsync.when(
          data: (items) {
            final filteredItems = _getFilteredItems(items);
            final categories = _getCategories(items);

            return Column(
              children: [
                // Search and Filters Section
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    border: Border(
                      bottom: BorderSide(
                        color: theme.dividerColor.withValues(alpha: 0.05),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.mediumGray.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadiusLarge,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: AppTheme.darkGray,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppTheme.darkGray,
                              size: 20,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: AppTheme.darkGray,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                      });
                                    },
                                    tooltip: 'Clear search',
                                  )
                                : null,
                            filled: false,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.2,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Location Filters
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildPillFilterChip(
                              context,
                              label: 'All Locations',
                              isSelected: _selectedLocationId == null,
                              onTap: () {
                                setState(() {
                                  _selectedLocationId = null;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            ...locations.map((location) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _buildPillFilterChip(
                                  context,
                                  label: location.name,
                                  isSelected:
                                      _selectedLocationId == location.id,
                                  onTap: () {
                                    setState(() {
                                      _selectedLocationId =
                                          _selectedLocationId == location.id
                                          ? null
                                          : location.id;
                                    });
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      // Category Filters
                      if (categories.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildPillFilterChip(
                                context,
                                label: 'All Categories',
                                isSelected: _selectedCategory == null,
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = null;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              ...categories.map((category) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: _buildPillFilterChip(
                                    context,
                                    label: category,
                                    isSelected: _selectedCategory == category,
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory =
                                            _selectedCategory == category
                                            ? null
                                            : category;
                                      });
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Items List
                Expanded(
                  child: filteredItems.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 80,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'No items found',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try adjusting your search or filters',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            ref.invalidate(itemsProvider);
                            await Future.delayed(
                              const Duration(milliseconds: 500),
                            );
                          },
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: filteredItems.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: ItemCard(
                                  item: item,
                                  onTap: () =>
                                      context.push('/items/${item.id}'),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error loading items: $error'),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading locations: $error'),
          ],
        ),
      ),
    );
  }

  Widget _buildPillFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryBlack
                : AppTheme.mediumGray.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
          ),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected ? AppTheme.primaryWhite : AppTheme.primaryBlack,
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

/// Locations tab content
class _LocationsTab extends ConsumerWidget {
  const _LocationsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsAsync = ref.watch(locationsProvider);
    final itemsAsync = ref.watch(itemsProvider);
    final theme = Theme.of(context);

    return locationsAsync.when(
      data: (locations) {
        if (locations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 16),
                Text(
                  'No locations found',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          );
        }

        return itemsAsync.when(
          data: (items) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(locationsProvider);
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: locations.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final location = locations[index];
                  final locationItems = items
                      .where((item) => item.currentLocation == location.id)
                      .toList();
                  final totalQuantity = locationItems.fold<int>(
                    0,
                    (sum, item) => sum + item.quantity,
                  );

                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.borderRadiusMedium,
                      ),
                      side: BorderSide(
                        color: theme.dividerColor.withValues(alpha: 0.05),
                        width: 0.5,
                      ),
                    ),
                    shadowColor: Colors.black.withValues(alpha: 0.08),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.location_on_outlined,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      title: Text(
                        location.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (location.description != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              location.description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (location.address != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.place_outlined,
                                  size: 14,
                                  color: AppTheme.secondaryLabel,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    location.address!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.secondaryLabel,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildStatChip(
                                context,
                                '${locationItems.length} Items',
                                Icons.inventory_2_outlined,
                              ),
                              _buildStatChip(
                                context,
                                'Qty: $totalQuantity',
                                Icons.numbers_outlined,
                              ),
                              if (location.isWarehouse &&
                                  location.warehouseCode != null)
                                _buildStatChip(
                                  context,
                                  location.warehouseCode!,
                                  Icons.warehouse_outlined,
                                ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Show location details
                      },
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error loading items: $error'),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading locations: $error'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, String label, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.systemGray5,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.secondaryLabel),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryLabel,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
