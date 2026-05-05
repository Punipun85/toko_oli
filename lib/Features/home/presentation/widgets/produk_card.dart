import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toko_oli/core/theme/app_theme.dart';
import 'package:toko_oli/features/product/domain/product.dart';

enum ProductCardLayout { featured, grid }

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.layout = ProductCardLayout.grid,
    this.onPrimaryAction,
    this.primaryActionIcon = Icons.add_shopping_cart_rounded,
    this.primaryActionTooltip,
    this.primaryActionLabel,
  });

  final Product product;
  final VoidCallback onTap;
  final ProductCardLayout layout;
  final VoidCallback? onPrimaryAction;
  final IconData primaryActionIcon;
  final String? primaryActionTooltip;
  final String? primaryActionLabel;

  bool get _isFeatured => layout == ProductCardLayout.featured;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final imageHeight = _isFeatured ? 144.0 : 112.0;
    final imageAspectRatio = null;
    final cardPadding = _isFeatured ? 14.0 : 12.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colors.outline),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: _isFeatured ? 28 : 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImagePanel(
                product: product,
                height: imageHeight,
                aspectRatio: imageAspectRatio,
              ),
              SizedBox(height: _isFeatured ? 12 : 12),
              Text(
                product.brand.toUpperCase(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.mutedText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.name,
                maxLines: _isFeatured ? 2 : 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SpecPill(label: product.sae),
                  _SpecPill(label: product.volume),
                  if (product.series != '-') _SpecPill(label: product.series),
                ],
              ),
              SizedBox(height: _isFeatured ? 12 : 8),
              const Spacer(),
              Text(
                product.hasPrice ? 'Harga mulai' : 'Status harga',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.mutedText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.price,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colors.accent,
                ),
              ),
              if (_isFeatured) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onTap,
                        child: const Text('Lihat detail'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Tooltip(
                      message: primaryActionTooltip ?? 'Tambah ke keranjang',
                      child: IconButton.filled(
                        onPressed: onPrimaryAction ?? onTap,
                        style: IconButton.styleFrom(
                          backgroundColor: colors.accent,
                          foregroundColor: Colors.white,
                        ),
                        icon: Icon(primaryActionIcon),
                      ),
                    ),
                  ],
                ),
              ],
              if (!_isFeatured) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onTap,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Lihat detail'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Tooltip(
                      message: primaryActionTooltip ?? 'Tambah ke keranjang',
                      child: IconButton.filled(
                        onPressed: onPrimaryAction ?? onTap,
                        style: IconButton.styleFrom(
                          backgroundColor: colors.accent,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.shopping_cart_rounded),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ProductImagePanel extends StatelessWidget {
  const ProductImagePanel({
    super.key,
    required this.product,
    this.height,
    this.aspectRatio,
  });

  final Product product;
  final double? height;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    Widget child = _ProductImageFallback(product: product);

    if (product.resolvedImageUrl case final imageUrl?) {
      final isSvg = imageUrl.toLowerCase().endsWith('.svg');
      child = ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: isSvg
            ? SvgPicture.network(
                imageUrl,
                fit: BoxFit.contain,
                placeholderBuilder: (_) => Stack(
                  fit: StackFit.expand,
                  children: [
                    _ProductImageFallback(product: product),
                    const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ],
                ),
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, image, progress) {
                  if (progress == null) {
                    return image;
                  }

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      _ProductImageFallback(product: product),
                      const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ],
                  );
                },
                errorBuilder: (_, _, _) => _ProductImageFallback(product: product),
              ),
      );
    }

    final panel = Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            context.appColors.surfaceMuted,
            const Color(0xFFE6EEFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );

    if (aspectRatio != null) {
      return AspectRatio(aspectRatio: aspectRatio!, child: panel);
    }

    return panel;
  }
}

class _ProductImageFallback extends StatelessWidget {
  const _ProductImageFallback({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 132;
        final padding = compact ? 12.0 : 18.0;
        final iconBox = compact ? 40.0 : 52.0;
        final iconSize = compact ? 22.0 : 28.0;
        final gap = compact ? 10.0 : 12.0;

        return Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 8 : 10,
                    vertical: compact ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    product.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: iconBox,
                    height: iconBox,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.local_gas_station_rounded,
                      color: colors.accent,
                      size: iconSize,
                    ),
                  ),
                  SizedBox(width: gap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          product.series == '-' ? product.brand : product.series,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${product.sae} | ${product.volume}',
                          maxLines: compact ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SpecPill extends StatelessWidget {
  const _SpecPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.outline),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: colors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
