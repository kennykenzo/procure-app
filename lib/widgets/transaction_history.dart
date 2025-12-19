import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:procurement_scanner/models/transaction.dart';
import 'package:procurement_scanner/models/location.dart';
import 'package:procurement_scanner/providers/items_provider.dart';
import 'package:procurement_scanner/providers/locations_provider.dart';
import 'package:procurement_scanner/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:procurement_scanner/widgets/clay_card.dart';

/// Transaction history widget
class TransactionHistory extends ConsumerWidget {
  final List<Transaction> transactions;
  final int? limit;

  const TransactionHistory({super.key, required this.transactions, this.limit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final itemsAsync = ref.watch(itemsProvider);
    final locationsAsync = ref.watch(locationsProvider);
    final displayTransactions = limit != null
        ? transactions.take(limit!).toList()
        : transactions;

    if (displayTransactions.isEmpty) {
      return const EmptyState(
        icon: Icons.history_outlined,
        message: 'No transactions yet',
      );
    }

    return itemsAsync.when(
      data: (items) {
        return locationsAsync.when(
          data: (locations) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...displayTransactions.map((txn) {
                  final item = items.firstWhere(
                    (i) => i.id == txn.itemId,
                    orElse: () => items.isNotEmpty
                        ? items.first
                        : throw Exception('No items available'),
                  );
                  final fromLocation = txn.fromLocation != null
                      ? locations.firstWhere(
                          (loc) => loc.id == txn.fromLocation,
                          orElse: () => Location(id: '', name: 'Unknown'),
                        )
                      : null;
                  final toLocation = txn.toLocation != null
                      ? locations.firstWhere(
                          (loc) => loc.id == txn.toLocation,
                          orElse: () => Location(id: '', name: 'Unknown'),
                        )
                      : null;

                  final txnColor = _getTransactionColor(txn.type);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ClayCard(
                      borderRadius: 22,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      onTap: () {},
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: txnColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getTransactionIcon(txn.type),
                              color: txnColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    letterSpacing: -0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (txn.materialCode != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    txn.materialCode!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.secondaryLabel,
                                      fontFamily: 'SF Mono',
                                      fontSize: 12,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 6),
                                Text(
                                  _getTransactionDescription(
                                    txn,
                                    fromLocation,
                                    toLocation,
                                  ),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 14,
                                    height: 1.3,
                                    letterSpacing: -0.1,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (txn.remarks != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    txn.remarks!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.secondaryLabel,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                const SizedBox(height: 6),
                                Text(
                                  DateFormat(
                                    'MMM d, y • h:mm a',
                                  ).format(txn.timestamp),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppTheme.secondaryLabel,
                                    fontSize: 12,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${txn.quantity}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: txnColor,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              if (txn.unitOfMeasure != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  txn.unitOfMeasure!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppTheme.secondaryLabel,
                                    fontSize: 12,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
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

  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.scanIn:
        return AppTheme.successGreen;
      case TransactionType.scanOut:
        return AppTheme.errorRed;
      case TransactionType.transfer:
        return AppTheme.primaryBlue;
    }
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.scanIn:
        return Icons.add_circle_outline;
      case TransactionType.scanOut:
        return Icons.remove_circle_outline;
      case TransactionType.transfer:
        return Icons.swap_horiz;
    }
  }

  String _getTransactionDescription(
    Transaction transaction,
    Location? fromLocation,
    Location? toLocation,
  ) {
    switch (transaction.type) {
      case TransactionType.scanIn:
        return toLocation != null
            ? 'Scanned in to ${toLocation.name}'
            : 'Scanned in';
      case TransactionType.scanOut:
        return fromLocation != null
            ? 'Scanned out from ${fromLocation.name}'
            : 'Scanned out';
      case TransactionType.transfer:
        if (fromLocation != null && toLocation != null) {
          return 'Transferred from ${fromLocation.name} to ${toLocation.name}';
        }
        return 'Transferred';
    }
  }
}

/// Empty state widget
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppTheme.systemGray3),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppTheme.secondaryLabel,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.tertiaryLabel,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
