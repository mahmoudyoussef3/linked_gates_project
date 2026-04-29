import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/product_entity.dart';
import 'product_grid_image_section.dart';
import 'product_grid_info_section.dart';

class ProductGridItem extends StatefulWidget {
  const ProductGridItem({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.priceText,
    this.onTap,
    this.onFavoriteTap,
    this.index = 0,
    this.animate = true,
  });

  final ProductEntity product;
  final bool isFavorite;
  final String priceText;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final int index;
  final bool animate;

  @override
  State<ProductGridItem> createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(curve);
    _scale = Tween<double>(begin: 0.98, end: 1).animate(curve);

    if (widget.animate) {
      final delay = Duration(milliseconds: 40 * (widget.index % 10));
      Future.delayed(delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant ProductGridItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && _controller.status == AnimationStatus.dismissed) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardRadius = BorderRadius.circular(16.r);
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          child: RepaintBoundary(
            child: Semantics(
              button: true,
              label: '${widget.product.title}, ${widget.priceText}',
              child: Material(
                color: AppColors.surface,
                elevation: 3,
                shadowColor: Colors.black.withValues(alpha: 0.08),
                borderRadius: cardRadius,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: cardRadius,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductGridImageSection(
                        productId: widget.product.id,
                        imageUrl: widget.product.imageUrl,
                        isFavorite: widget.isFavorite,
                        onFavoriteTap: widget.onFavoriteTap,
                      ),
                      ProductGridInfoSection(
                        title: widget.product.title,
                        priceText: widget.priceText,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
