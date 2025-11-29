import 'package:flutter/material.dart';
import 'package:procurement_scanner/theme/app_theme.dart';

/// Apple-style scan button widget
class ScanButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? label;
  final bool isLarge;

  const ScanButton({
    super.key,
    required this.onTap,
    this.label,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLarge) {
      return Card(
        elevation: 0,
        margin: EdgeInsets.zero,
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
            splashColor: AppTheme.primaryBlack.withValues(alpha: 0.1),
            highlightColor: AppTheme.primaryBlack.withValues(alpha: 0.05),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppTheme.borderRadiusMedium,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlack.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 48,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    label ?? 'Scan Item',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      letterSpacing: -0.5,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Barcode or NFC',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondaryLabel,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.qr_code_scanner, size: 20),
      label: Text(label ?? 'Scan'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }
}
