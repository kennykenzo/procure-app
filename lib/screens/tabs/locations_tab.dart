import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:procurement_scanner/models/location.dart';
import 'package:procurement_scanner/providers/items_provider.dart';
import 'package:procurement_scanner/providers/locations_provider.dart';
import 'package:procurement_scanner/theme/app_theme.dart';

/// Locations tab content - Redesigned with modern card layout
class LocationsTab extends ConsumerWidget {
  const LocationsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsAsync = ref.watch(locationsProvider);
    final itemsAsync = ref.watch(itemsProvider);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return locationsAsync.when(
      data: (locations) {
        if (locations.isEmpty) {
          return _EmptyState(theme: theme);
        }

        return itemsAsync.when(
          data: (items) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(locationsProvider);
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Improved Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Locations',
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
                                  '${locations.length} location${locations.length != 1 ? 's' : ''} registered',
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
                              onTap: () {
                                // TODO: Add location dialog
                              },
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
                    ),
                  ),

                  // Locations List with improved design
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final location = locations[index];
                        final locationItems = items
                            .where(
                              (item) => item.currentLocation == location.id,
                            )
                            .toList();
                        final totalQuantity = locationItems.fold<int>(
                          0,
                          (sum, item) => sum + item.quantity,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ModernLocationCard(
                            location: location,
                            itemCount: locationItems.length,
                            totalQuantity: totalQuantity,
                            onTap: () {
                              // TODO: Show location details
                            },
                          ),
                        );
                      }, childCount: locations.length),
                    ),
                  ),
                ],
              ),
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
}

class _ModernLocationCard extends StatelessWidget {
  final Location location;
  final int itemCount;
  final int totalQuantity;
  final VoidCallback onTap;

  const _ModernLocationCard({
    required this.location,
    required this.itemCount,
    required this.totalQuantity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.claySurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.darkGray.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon with gradient background
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primary, primary.withValues(alpha: 0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: AppTheme.primaryWhite,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            fontSize: 18,
                            color: AppTheme.primaryBlack,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (location.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            location.description!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.darkGray.withValues(alpha: 0.7),
                              fontSize: 13,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.darkGray.withValues(alpha: 0.4),
                    size: 24,
                  ),
                ],
              ),

              if (location.address != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryWhite.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 16,
                        color: AppTheme.darkGray.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location.address!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.darkGray.withValues(alpha: 0.75),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),
              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _StatBadge(
                      icon: Icons.inventory_2_outlined,
                      label: '$itemCount',
                      sublabel: 'items',
                      color: AppTheme.clayPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatBadge(
                      icon: Icons.numbers_outlined,
                      label: '$totalQuantity',
                      sublabel: 'qty',
                      color: AppTheme.claySecondary,
                    ),
                  ),
                  if (location.isWarehouse &&
                      location.warehouseCode != null) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatBadge(
                        icon: Icons.warehouse_outlined,
                        label: location.warehouseCode!,
                        sublabel: 'code',
                        color: AppTheme.clayOrange,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;

  const _StatBadge({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.primaryBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  sublabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.darkGray.withValues(alpha: 0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ThemeData theme;

  const _EmptyState({required this.theme});

  @override
  Widget build(BuildContext context) {
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
                color: AppTheme.claySurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off_outlined,
                size: 48,
                color: AppTheme.darkGray.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No locations yet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryBlack,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first location to organize items',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkGray.withValues(alpha: 0.6),
                fontSize: 15,
              ),
            ),
          ],
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
