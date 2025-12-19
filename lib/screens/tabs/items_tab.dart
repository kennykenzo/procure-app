import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:procurement_scanner/models/item.dart';
import 'package:procurement_scanner/providers/items_provider.dart';
import 'package:procurement_scanner/providers/locations_provider.dart';
import 'package:procurement_scanner/theme/app_theme.dart';
import 'package:procurement_scanner/widgets/item_card.dart';

/// Items tab content - Redesigned with better visual flow
class ItemsTab extends ConsumerStatefulWidget {
  const ItemsTab({super.key});

  @override
  ConsumerState<ItemsTab> createState() => _ItemsTabState();
}

class _ItemsTabState extends ConsumerState<ItemsTab> {
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
    final primary = theme.colorScheme.primary;

    return locationsAsync.when(
      data: (locations) {
        return itemsAsync.when(
          data: (items) {
            final filteredItems = _getFilteredItems(items);
            final categories = _getCategories(items);
            final hasActiveFilters =
                _selectedLocationId != null || _selectedCategory != null;

            return Column(
              children: [
                // Redesigned Header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Add Button Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Items',
                                  style: theme.textTheme.headlineLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -1.0,
                                        fontSize: 32,
                                        color: AppTheme.primaryBlack,
                                        height: 1.1,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${items.length} items available',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.darkGray.withValues(
                                      alpha: 0.7,
                                    ),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Material(
                            color: primary,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              onTap: () => context.push('/manual-entry'),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primary.withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  color: AppTheme.primaryWhite,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Modern Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.claySurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _searchController.text.isNotEmpty
                                ? primary.withValues(alpha: 0.3)
                                : AppTheme.darkGray.withValues(alpha: 0.08),
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search by name, code, barcode...',
                            hintStyle: TextStyle(
                              color: AppTheme.darkGray.withValues(alpha: 0.5),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(
                                Icons.search_rounded,
                                color: primary,
                                size: 22,
                              ),
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.close_rounded,
                                      color: AppTheme.darkGray.withValues(
                                        alpha: 0.5,
                                      ),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                      });
                                    },
                                  )
                                : null,
                            filled: false,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),

                      // Filters Section
                      if (locations.isNotEmpty || categories.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    // Location Filters
                                    if (locations.isNotEmpty) ...[
                                      ...locations.map((location) {
                                        final isSelected =
                                            _selectedLocationId == location.id;
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          child: _buildFilterChip(
                                            context,
                                            label: location.name,
                                            isSelected: isSelected,
                                            onTap: () {
                                              setState(() {
                                                _selectedLocationId = isSelected
                                                    ? null
                                                    : location.id;
                                              });
                                            },
                                          ),
                                        );
                                      }),
                                    ],
                                    // Category Filters
                                    if (categories.isNotEmpty) ...[
                                      ...categories.map((category) {
                                        final isSelected =
                                            _selectedCategory == category;
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          child: _buildFilterChip(
                                            context,
                                            label: category,
                                            isSelected: isSelected,
                                            onTap: () {
                                              setState(() {
                                                _selectedCategory = isSelected
                                                    ? null
                                                    : category;
                                              });
                                            },
                                          ),
                                        );
                                      }),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            if (hasActiveFilters) ...[
                              const SizedBox(width: 8),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedLocationId = null;
                                      _selectedCategory = null;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.claySurface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppTheme.darkGray.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 18,
                                      color: AppTheme.darkGray,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
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
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    color: AppTheme.claySurface,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.inventory_2_outlined,
                                    size: 48,
                                    color: AppTheme.darkGray.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'No items found',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primaryBlack,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  hasActiveFilters
                                      ? 'Try removing some filters'
                                      : 'Start by adding your first item',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.darkGray.withValues(
                                      alpha: 0.6,
                                    ),
                                    fontSize: 15,
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
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                            itemCount: filteredItems.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              return ItemCard(
                                item: item,
                                onTap: () => context.push('/items/${item.id}'),
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              _ErrorState(message: 'Error loading items: $error'),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          _ErrorState(message: 'Error loading locations: $error'),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? primary : AppTheme.claySurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? primary
                  : AppTheme.darkGray.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isSelected
                  ? AppTheme.primaryWhite
                  : AppTheme.primaryBlack.withValues(alpha: 0.75),
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryBlack,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkGray.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
