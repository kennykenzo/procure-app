import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:procurement_scanner/models/location.dart';
import 'package:procurement_scanner/providers/items_provider.dart';
import 'package:procurement_scanner/providers/locations_provider.dart';
import 'package:procurement_scanner/providers/transactions_provider.dart';
import 'package:procurement_scanner/theme/app_theme.dart';
import 'package:procurement_scanner/widgets/transaction_history.dart';

/// Item detail screen
class ItemDetailScreen extends ConsumerWidget {
  final String itemId;

  const ItemDetailScreen({
    super.key,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(itemByIdProvider(itemId));
    final locationsAsync = ref.watch(locationsProvider);
    final transactionsAsync = ref.watch(transactionsByItemProvider(itemId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit screen
            },
            tooltip: 'Edit Item',
          ),
        ],
      ),
      body: itemAsync.when(
        data: (item) {
          if (item == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Item not found',
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }

          return locationsAsync.when(
            data: (locations) {
              final location = locations.firstWhere(
                (loc) => loc.id == item.currentLocation,
                orElse: () => Location(id: item.currentLocation, name: 'Unknown'),
              );

              return transactionsAsync.when(
                data: (itemTransactions) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item Header Card
                        Card(
                          margin: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: theme.dividerColor.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: theme.textTheme.headlineSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: -0.5,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (item.materialCode.isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              'Material Code: ${item.materialCode}',
                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                color: AppTheme.secondaryLabel,
                                                fontFamily: 'SF Mono',
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${item.quantity} ${item.unitOfMeasure ?? 'pcs'}',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          color: AppTheme.primaryBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.description != null) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    item.description!,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                                if (item.specification != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'Specification: ${item.specification}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.secondaryLabel,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                if (item.category != null || item.isOfficeStock) ...[
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      if (item.category != null)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.category_outlined,
                                              size: 18,
                                              color: AppTheme.secondaryLabel,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              item.category!,
                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                color: AppTheme.secondaryLabel,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (item.isOfficeStock)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppTheme.successGreen.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            'Office Stock',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: AppTheme.successGreen,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 18,
                                      color: AppTheme.secondaryLabel,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            location.name,
                                            style: theme.textTheme.bodyMedium,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (location.description != null)
                                            Text(
                                              location.description!,
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: AppTheme.secondaryLabel,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Item Information
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Information',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (item.unitOfMeasure != null)
                                _buildInfoRow(
                                  context,
                                  'Unit of Measure',
                                  item.unitOfMeasure!,
                                  Icons.straighten,
                                ),
                              _buildInfoRow(
                                context,
                                'Barcode',
                                item.barcode ?? 'Not set',
                                Icons.qr_code_2_outlined,
                              ),
                              _buildInfoRow(
                                context,
                                'NFC ID',
                                item.nfcId ?? 'Not set',
                                Icons.nfc_outlined,
                              ),
                              if (item.supplier != null)
                                _buildInfoRow(
                                  context,
                                  'Supplier',
                                  item.supplier!,
                                  Icons.business_outlined,
                                ),
                              _buildInfoRow(
                                context,
                                'Created',
                                DateFormat('MMM d, y • h:mm a').format(item.createdAt),
                                Icons.calendar_today_outlined,
                              ),
                              _buildInfoRow(
                                context,
                                'Last Updated',
                                DateFormat('MMM d, y • h:mm a').format(item.updatedAt),
                                Icons.update_outlined,
                              ),
                              if (item.notes != null && item.notes!.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: theme.dividerColor.withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.note_outlined,
                                              size: 18,
                                              color: AppTheme.secondaryLabel,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Notes',
                                              style: theme.textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          item.notes!,
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Actions
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () => context.push('/scan'),
                                  icon: const Icon(Icons.qr_code_scanner),
                                  label: const Text('Scan In/Out'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    // TODO: Transfer location
                                  },
                                  icon: const Icon(Icons.swap_horiz),
                                  label: const Text('Transfer Location'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Transaction History
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Transaction History',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TransactionHistory(transactions: itemTransactions),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error loading transactions: $error'),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error loading locations: $error'),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading item',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '$error',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.secondaryLabel),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryLabel,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
