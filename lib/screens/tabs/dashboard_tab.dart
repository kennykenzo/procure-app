import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:procurement_scanner/providers/items_provider.dart';
import 'package:procurement_scanner/providers/transactions_provider.dart';
import 'package:procurement_scanner/theme/app_theme.dart';
import 'package:procurement_scanner/widgets/stat_card.dart';
import 'package:procurement_scanner/widgets/transaction_history.dart';

/// Dashboard tab content - Redesigned for better visual hierarchy
class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
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
                  // Improved header with better spacing
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      primary,
                                      primary.withValues(alpha: 0.7),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primary.withValues(alpha: 0.25),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: AppTheme.primaryWhite,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello,',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: AppTheme.darkGray.withValues(
                                              alpha: 0.75,
                                            ),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Procurement',
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -0.5,
                                            fontSize: 24,
                                            color: AppTheme.primaryBlack,
                                            height: 1.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              _ModernIconButton(
                                icon: Icons.search_rounded,
                                onTap: () {},
                              ),
                              const SizedBox(width: 8),
                              _ModernIconButton(
                                icon: Icons.tune_rounded,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Enhanced hero card with gradient background
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: GestureDetector(
                        onTap: () => context.push('/scan'),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primary,
                                primary.withValues(alpha: 0.85),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'QUICK ACTION',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: AppTheme.primaryWhite
                                                  .withValues(alpha: 0.9),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10,
                                              letterSpacing: 0.5,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Scan Items',
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -0.5,
                                            color: AppTheme.primaryWhite,
                                            fontSize: 26,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Barcode · QR · NFC',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: AppTheme.primaryWhite
                                                .withValues(alpha: 0.85),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.qr_code_scanner_rounded,
                                  color: AppTheme.primaryWhite,
                                  size: 36,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Section header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Overview',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                              fontSize: 20,
                              color: AppTheme.primaryBlack,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'See all',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Stats Grid with improved spacing
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.35,
                          ),
                      delegate: SliverChildListDelegate([
                        StatCard(
                          title: 'Total Items',
                          value: totalItems.toString(),
                          icon: Icons.inventory_2_rounded,
                          iconColor: AppTheme.clayPrimary,
                        ),
                        StatCard(
                          title: 'Total Quantity',
                          value: totalQuantity.toString(),
                          icon: Icons.numbers_rounded,
                          iconColor: AppTheme.claySecondary,
                        ),
                        StatCard(
                          title: 'Locations',
                          value: '5',
                          icon: Icons.location_on_rounded,
                          iconColor: AppTheme.clayOrange,
                        ),
                        StatCard(
                          title: 'Recent Activity',
                          value: recentActivity.toString(),
                          icon: Icons.history_rounded,
                          iconColor: AppTheme.clayPink,
                        ),
                      ]),
                    ),
                  ),

                  // Recent Activity Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Activity',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                              fontSize: 20,
                              color: AppTheme.primaryBlack,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.push('/transactions'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'View all',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: primary,
                                  ),
                                ],
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
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
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

class _ModernIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ModernIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.claySurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.darkGray.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Icon(icon, color: primary, size: 20),
        ),
      ),
    );
  }
}
