import 'package:flutter/material.dart';
import 'package:toko_oli/core/theme/app_theme.dart';

class PremiumPageBackground extends StatelessWidget {
  const PremiumPageBackground({
    super.key,
    required this.child,
    this.headerHeight = 220,
  });

  final Widget child;
  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.primary,
            const Color(0xFF1D2738),
            colors.background,
            colors.background,
          ],
          stops: const [0, 0.18, 0.18, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 56,
            right: -24,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.accent.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            top: 112,
            left: -18,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.gold.withValues(alpha: 0.10),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: child,
          ),
        ],
      ),
    );
  }
}

class PremiumCard extends StatelessWidget {
  const PremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 24,
    this.backgroundColor,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? colors.outline),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: theme.textTheme.bodyMedium),
              ],
            ],
          ),
        ),
        if (action != null) ...[
          const SizedBox(width: 12),
          action!,
        ],
      ],
    );
  }
}

class MetricPill extends StatelessWidget {
  const MetricPill({
    super.key,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
  });

  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: foregroundColor ?? colors.primary),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: foregroundColor ?? colors.primary,
                ),
          ),
        ],
      ),
    );
  }
}

class AppSectionButton extends StatelessWidget {
  const AppSectionButton({
    super.key,
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(label),
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.action,
  });

  final String title;
  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: colors.primary),
          ),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (action != null) ...[
            const SizedBox(height: 18),
            action!,
          ],
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
  });

  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: foregroundColor ?? colors.primary),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: foregroundColor ?? colors.primary,
                ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.subtitle,
    this.highlightColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? subtitle;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final highlight = highlightColor ?? colors.accent;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: highlight.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: highlight),
          ),
          const SizedBox(height: 16),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.height = 16,
    this.width,
    this.radius = 12,
  });

  final double height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class LoadingCard extends StatelessWidget {
  const LoadingCard({super.key, this.lines = 3});

  final int lines;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(height: 18, width: 120),
          const SizedBox(height: 16),
          for (var index = 0; index < lines; index++) ...[
            SkeletonBox(
              height: 14,
              width: index == lines - 1 ? 140 : double.infinity,
            ),
            if (index != lines - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class TimelineStep extends StatelessWidget {
  const TimelineStep({
    super.key,
    required this.title,
    required this.subtitle,
    this.isActive = false,
    this.isLast = false,
  });

  final String title;
  final String subtitle;
  final bool isActive;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? colors.accent : colors.surfaceSoft,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 42,
                color: colors.surfaceSoft,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
