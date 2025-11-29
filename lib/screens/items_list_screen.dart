import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:procurement_scanner/models/item.dart';
import 'package:procurement_scanner/providers/items_provider.dart';
import 'package:procurement_scanner/providers/locations_provider.dart';
import 'package:procurement_scanner/widgets/item_card.dart';

/// Items list screen with search and filter
class ItemsListScreen extends ConsumerStatefulWidget {
  const ItemsListScreen({super.key});

  @override
  ConsumerState<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends ConsumerState<ItemsListScreen> {
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

    // Apply search
    if (searchQuery.isNotEmpty) {
      final lowerQuery = searchQuery.toLowerCase();
      filteredItems = filteredItems.where((item) {
        return item.name.toLowerCase().contains(lowerQuery) ||
            (item.barcode?.toLowerCase().contains(lowerQuery) ?? false) ||
            (item.category?.toLowerCase().contains(lowerQuery) ?? false) ||
            item.materialCode.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    // Apply location filter
    if (_selectedLocationId != null) {
      filteredItems = filteredItems
          .where((item) => item.currentLocation == _selectedLocationId)
          .toList();
    }

    // Apply category filter
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/manual-entry'),
            tooltip: 'Add Item',
          ),
        ],
      ),
      body: SafeArea(
        child: locationsAsync.when(
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
                            color: theme.dividerColor.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                                children: [
                                  TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      labelText: 'Search items',
                                      hintText: 'Name, barcode, category...',
                                      prefixIcon: const Icon(Icons.search),
                                      suffixIcon: _searchController.text.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(Icons.clear),
                                              onPressed: () {
                                                setState(() {
                                                  _searchController.clear();
                                                });
                                              },
                                              tooltip: 'Clear search',
                                            )
                                          : null,
                                      filled: true,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                  const SizedBox(height: 12),
                                  // Location Filters
                                  SizedBox(
                                    height: 36,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        FilterChip(
                                          label: const Text('All Locations'),
                                          selected: _selectedLocationId == null,
                                          onSelected: (selected) {
                                            setState(() {
                                              _selectedLocationId = null;
                                            });
                                          },
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                        ),
                                        const SizedBox(width: 8),
                                        ...locations.map((location) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 8),
                                            child: FilterChip(
                                              label: Text(
                                                location.name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              selected: _selectedLocationId == location.id,
                                              onSelected: (selected) {
                                                setState(() {
                                                  _selectedLocationId = selected ? location.id : null;
                                                });
                                              },
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                      height: 36,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          FilterChip(
                                            label: const Text('All Categories'),
                                            selected: _selectedCategory == null,
                                            onSelected: (selected) {
                                              setState(() {
                                                _selectedCategory = null;
                                              });
                                            },
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                          ),
                                          const SizedBox(width: 8),
                                          ...categories.map((category) {
                                            return Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: FilterChip(
                                                label: Text(
                                                  category,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                selected: _selectedCategory == category,
                                                onSelected: (selected) {
                                                  setState(() {
                                                    _selectedCategory = selected ? category : null;
                                                  });
                                                },
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      'No items found',
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Try adjusting your search or filters',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                ref.invalidate(itemsProvider);
                                await Future.delayed(const Duration(milliseconds: 500));
                              },
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                itemCount: filteredItems.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final item = filteredItems[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: ItemCard(
                                      item: item,
                                      onTap: () => context.push('/items/${item.id}'),
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
        ),
      ),
    );
  }
}
