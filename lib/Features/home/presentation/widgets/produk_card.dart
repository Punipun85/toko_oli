import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    final imageHeight = _isFeatured ? 132.0 : 118.0;
    final imageAspectRatio = _isFeatured ? null : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1C2024),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFF313539)),
            boxShadow: _isFeatured
                ? const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 24,
                      offset: Offset(0, 14),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImagePanel(
                product: product,
                height: imageHeight,
                aspectRatio: imageAspectRatio,
              ),
              SizedBox(height: _isFeatured ? 12 : 14),
              Text(
                product.brand.toUpperCase(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFA98A7D),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SpecPill(label: product.sae),
                  _SpecPill(label: product.volume),
                  if (product.series != '-') _SpecPill(label: product.series),
                ],
              ),
              SizedBox(height: _isFeatured ? 12 : 10),
              if (_isFeatured) const Spacer(),
              Text(
                product.hasPrice ? 'Harga mulai' : 'Status harga',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFA98A7D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.price,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFFFB693),
                ),
              ),
              if (_isFeatured) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onTap,
                        child: const Text('Detail'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Tooltip(
                      message: primaryActionTooltip ?? 'Tambah ke keranjang',
                      child: IconButton.filled(
                        onPressed: onPrimaryAction ?? onTap,
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B00),
                          foregroundColor: Colors.black,
                        ),
                        icon: Icon(primaryActionIcon),
                      ),
                    ),
                  ],
                ),
              ],
              if (!_isFeatured && primaryActionLabel != null) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onPrimaryAction ?? onTap,
                    child: Text(primaryActionLabel!),
                  ),
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
        gradient: const LinearGradient(
          colors: [Color(0xFF313539), Color(0xFF181C20)],
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
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    product.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFFFD3BF),
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
                      color: const Color(0x14FFFFFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.local_gas_station_rounded,
                      color: const Color(0xFFFFB693),
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
                            color: const Color(0xFFFFD3BF),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${product.sae} | ${product.volume}',
                          maxLines: compact ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFFFFB693),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF262A2E),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF3C4247)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFFE0E3E8),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
