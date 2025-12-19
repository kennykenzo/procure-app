import 'package:flutter/material.dart';

/// Claymorphism-style card with soft highlights and shadows.
class ClayCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? color;

  const ClayCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = color ?? theme.colorScheme.surface;
    final radius = BorderRadius.circular(borderRadius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: base,
        borderRadius: radius,
        boxShadow: [
          // Dark shadow (bottom-right)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(10, 10),
            spreadRadius: 0,
          ),
          // Light highlight (top-left)
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.85),
            blurRadius: 18,
            offset: const Offset(-10, -10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}


