import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:procurement_scanner/models/item.dart';
import 'package:procurement_scanner/models/location.dart';
import 'package:procurement_scanner/providers/locations_provider.dart';
import 'package:procurement_scanner/theme/app_theme.dart';

/// Item card widget for displaying item information
class ItemCard extends ConsumerWidget {
  final Item item;
  final VoidCallback? onTap;

  const ItemCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locationsAsync = ref.watch(locationsProvider);

    return locationsAsync.when(
      data: (locations) {
        final location = locations.firstWhere(
          (loc) => loc.id == item.currentLocation,
          orElse: () => Location(id: item.currentLocation, name: 'Unknown'),
        );

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            side: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.05),
              width: 0.5,
            ),
          ),
          shadowColor: Colors.black.withValues(alpha: 0.08),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (item.materialCode.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.materialCode,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppTheme.secondaryLabel,
                                    fontFamily: 'SF Mono',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlack,
                            borderRadius: BorderRadius.circular(
                              AppTheme.borderRadiusXLarge,
                            ),
                          ),
                          child: Text(
                            '${item.quantity} ${item.unitOfMeasure ?? 'pcs'}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Category and Office Stock Badge
                    if (item.category != null || item.isOfficeStock) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (item.category != null)
                            _buildCategoryChip(context, item.category!),
                          if (item.isOfficeStock)
                            _buildOfficeStockBadge(context),
                        ],
                      ),
                    ],

                    // Location
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppTheme.secondaryLabel,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            location.name,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.secondaryLabel,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // Barcode/NFC Badges
                    if (item.barcode != null || item.nfcId != null) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (item.barcode != null)
                            _buildBadge(
                              context,
                              Icons.qr_code_2_outlined,
                              'Barcode',
                              size: 12,
                            ),
                          if (item.nfcId != null)
                            _buildBadge(
                              context,
                              Icons.nfc_outlined,
                              'NFC',
                              size: 12,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String category) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.mediumGray.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.category_outlined, size: 14, color: AppTheme.darkGray),
          const SizedBox(width: 6),
          Text(
            category,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.darkGray,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildOfficeStockBadge(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accentGreen.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
      ),
      child: Text(
        'Office Stock',
        style: theme.textTheme.bodySmall?.copyWith(
          color: AppTheme.accentGreen,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  Widget _buildBadge(
    BuildContext context,
    IconData icon,
    String label, {
    double size = 12,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.mediumGray.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: size, color: AppTheme.darkGray),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.darkGray,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
