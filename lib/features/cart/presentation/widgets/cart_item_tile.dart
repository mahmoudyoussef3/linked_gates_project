import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/price_extensions.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../provider/cart_provider.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({super.key, required this.item});

  final CartItemEntity item;

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    return Material(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox(
                width: 72.w,
                height: 72.w,
                child: AppNetworkImage(url: item.imageUrl),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        item.unitPrice.formatCurrency(),
                        style: AppTextStyles.price,
                      ),
                      SizedBox(width: 8.w),
                      SizeChip(size: item.size.name.toUpperCase()),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Total: ${item.totalPrice.formatCurrency()}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () => cart.remove(item.productId, item.size),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18.r,
                    color: AppColors.textSecondary,
                  ),
                ),
                QuantityStepper(
                  quantity: item.quantity,
                  onAdd: () => cart.increase(item.productId, item.size),
                  onRemove: () => cart.decrease(item.productId, item.size),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StepperButton(icon: Icons.add, onTap: onAdd),
        SizedBox(height: 8.h),
        Text(quantity.toString(), style: AppTextStyles.title),
        SizedBox(height: 8.h),
        StepperButton(icon: Icons.remove, onTap: onRemove),
      ],
    );
  }
}

class StepperButton extends StatelessWidget {
  const StepperButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: Icon(icon, size: 16.r, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class SizeChip extends StatelessWidget {
  const SizeChip({super.key, required this.size});

  final String size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.muted),
      ),
      child: Text(
        size,
        style: AppTextStyles.caption,
      ),
    );
  }
}
