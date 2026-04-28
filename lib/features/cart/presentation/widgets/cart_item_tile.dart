import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linked_gates_project/features/cart/presentation/widgets/item_details.dart';
import 'package:linked_gates_project/features/cart/presentation/widgets/item_img.dart';
import 'package:linked_gates_project/features/cart/presentation/widgets/quantity_stepper.dart';
import 'package:provider/provider.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../provider/cart_provider.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({super.key, required this.item});

  final CartItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            ItemImage(imageUrl: item.imageUrl),
            SizedBox(width: 12.w),
            Expanded(child: ItemDetails(item: item)),
            Column(
              children: [
                IconButton(
                  onPressed: () => context.read<CartProvider>().remove(
                    item.productId,
                    item.size,
                  ),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18.r,
                    color: AppColors.textSecondary,
                  ),
                ),
                QuantityStepper(item: item),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
