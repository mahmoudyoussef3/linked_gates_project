import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../app_router.dart';
import '../../../products/presentation/provider/cart_provider.dart';
import '../../../../core/extensions/price_extensions.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/app_message_view.dart';
import '../../../../core/widgets/app_network_image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => _handleBack(context),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return const AppMessageView(
              message: 'Your cart is empty.',
              icon: Icons.shopping_bag_outlined,
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return _CartItemTile(item: item);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text('Total', style: AppTextStyles.subtitle),
                    const Spacer(),
                    Text(
                      cart.formattedTotalPrice,
                      style: AppTextStyles.priceLarge,
                    ),
                    SizedBox(width: 12.w),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pushReplacementNamed(AppRoutes.products);
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});

  final CartItem item;

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
                      _SizeChip(size: item.size.name.toUpperCase()),
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
                _QuantityStepper(
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

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
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
        _StepperButton(icon: Icons.add, onTap: onAdd),
        SizedBox(height: 8.h),
        Text(quantity.toString(), style: AppTextStyles.title),
        SizedBox(height: 8.h),
        _StepperButton(icon: Icons.remove, onTap: onRemove),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

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

class _SizeChip extends StatelessWidget {
  const _SizeChip({required this.size});

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
