import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../app_router.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../cart/domain/entities/cart_size.dart';
import '../../../cart/presentation/provider/cart_provider.dart';

class QuantityButton extends StatelessWidget {
  const QuantityButton({super.key, required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Icon(
            icon,
            size: 18.r,
            color: onTap == null ? AppColors.muted : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class InlineQuantityCounter extends StatelessWidget {
  const InlineQuantityCounter({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback? onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.muted.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          QuantityButton(icon: Icons.remove, onTap: onDecrease),
          SizedBox(width: 8.w),
          Text(
            quantity.toString(),
            style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(width: 8.w),
          QuantityButton(icon: Icons.add, onTap: onIncrease),
        ],
      ),
    );
  }
}

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.muted.withValues(alpha: 0.6),
      height: 1,
      thickness: 1,
    );
  }
}

class ProductSizeSelector extends StatelessWidget {
  const ProductSizeSelector({
    super.key,
    required this.selectedSize,
    required this.onSelected,
  });

  final CartSize selectedSize;
  final ValueChanged<CartSize> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: CartSize.values.map((size) {
        final isSelected = size == selectedSize;
        return Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: InkWell(
            onTap: () => onSelected(size),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.muted.withValues(alpha: 0.8),
                ),
              ),
              child: Text(
                size.name.toUpperCase(),
                style: AppTextStyles.subtitle.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

void showProductDetailsCartSnackBar(BuildContext context) {
  showAppSnackBar(
    context,
    message: 'Added to cart',
    actionLabel: 'View cart',
    onAction: () {
      Navigator.of(context).pushNamed(
        AppRoutes.cart,
        arguments: CartArgs(
          cartProvider: context.read<CartProvider>(),
        ),
      );
    },
  );
}
