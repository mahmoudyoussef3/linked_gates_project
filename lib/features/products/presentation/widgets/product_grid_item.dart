import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../domain/entities/product_entity.dart';

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
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          child: RepaintBoundary(
            child: Material(
              color: AppColors.surface,
              elevation: 3,
              shadowColor: Colors.black.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16.r),
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Hero(
                        tag: 'product_${widget.product.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.r),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              AppNetworkImage(url: widget.product.imageUrl),
                              Positioned(
                                top: 10.h,
                                right: 10.w,
                                child: FavoriteButton(
                                  isFavorite: widget.isFavorite,
                                  onTap: widget.onFavoriteTap,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 6.h),
                      child: Text(
                        widget.product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.title,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          widget.priceText,
                          style: AppTextStyles.price,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.isFavorite, this.onTap});

  final bool isFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = isFavorite ? AppColors.error : Colors.white;
    return Material(
      color: Colors.black.withValues(alpha: 0.25),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(isFavorite),
              color: color,
              size: 18.r,
            ),
          ),
        ),
      ),
    );
  }
}
