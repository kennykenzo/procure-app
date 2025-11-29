import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:procurement_scanner/providers/locations_provider.dart';
import 'package:procurement_scanner/theme/app_theme.dart';

/// Location selector widget
class LocationSelector extends ConsumerWidget {
  final String? selectedLocationId;
  final ValueChanged<String?> onLocationChanged;
  final String? label;

  const LocationSelector({
    super.key,
    this.selectedLocationId,
    required this.onLocationChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locationsAsync = ref.watch(locationsProvider);

    return locationsAsync.when(
      data: (locations) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) ...[
              Text(
                label!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Container(
              decoration: BoxDecoration(
                color: theme.inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonFormField<String>(
                initialValue: selectedLocationId,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  hintText: 'Select location',
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('None'),
                  ),
                  ...locations.map((location) {
                    return DropdownMenuItem<String>(
                      value: location.id,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: AppTheme.primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  location.name,
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
                    );
                  }),
                ],
                onChanged: onLocationChanged,
              ),
            ),
          ],
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text('Error: $error'),
      ),
    );
  }
}
