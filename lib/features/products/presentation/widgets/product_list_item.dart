import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../cart/domain/entities/cart_size.dart';
import '../../domain/entities/product_entity.dart';
import 'product_grid_item.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.priceText,
    required this.description,
    required this.selectedSize,
    required this.quantity,
    this.onTap,
    this.onFavoriteTap,
    this.onIncrease,
    this.onDecrease,
    this.onSizeSelected,
  });

  final ProductEntity product;
  final bool isFavorite;
  final String priceText;
  final String description;
  final CartSize selectedSize;
  final int quantity;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final ValueChanged<CartSize>? onSizeSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'product_${product.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: SizedBox(
                    width: 96.w,
                    height: 96.w,
                    child: AppNetworkImage(url: product.imageUrl),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.title,
                          ),
                        ),
                        FavoriteButton(
                          isFavorite: isFavorite,
                          onTap: onFavoriteTap,
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(priceText, style: AppTextStyles.price),
                    SizedBox(height: 6.h),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.description,
                    ),
                    SizedBox(height: 10.h),
                    _SizeSelector(
                      selectedSize: selectedSize,
                      onSelected: onSizeSelected,
                    ),
                    SizedBox(height: 10.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _Counter(
                        quantity: quantity,
                        onIncrease: onIncrease,
                        onDecrease: onDecrease,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  const _SizeSelector({
    required this.selectedSize,
    this.onSelected,
  });

  final CartSize selectedSize;
  final ValueChanged<CartSize>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: CartSize.values.map((size) {
        final isSelected = size == selectedSize;
        return Padding(
          padding: EdgeInsets.only(right: 6.w),
          child: InkWell(
            onTap: onSelected == null ? null : () => onSelected!(size),
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.muted.withValues(alpha: 0.8),
                ),
              ),
              child: Text(
                size.name.toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({
    required this.quantity,
    this.onIncrease,
    this.onDecrease,
  });

  final int quantity;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CounterButton(
            icon: Icons.remove,
            onTap: onDecrease,
            enabled: quantity > 0,
          ),
          SizedBox(width: 8.w),
          Text(
            quantity.toString(),
            style: AppTextStyles.subtitle,
          ),
          SizedBox(width: 8.w),
          _CounterButton(
            icon: Icons.add,
            onTap: onIncrease,
            enabled: true,
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? AppColors.primary : AppColors.muted,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: Icon(
            icon,
            size: 14.r,
            color: enabled ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
