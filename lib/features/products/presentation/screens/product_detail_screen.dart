import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../provider/product_provider.dart';
import '../../domain/entities/product_entity.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          final priceText = provider.getFormattedPrice(product);
          final description = provider.getDescription(product);
          final quantity = provider.getQuantity(product.id);
          final totalPrice = provider.getFormattedTotalPrice(product);

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'product_${product.id}',
                  child: AspectRatio(
                    aspectRatio: 1.1,
                    child: AppNetworkImage(
                      url: product.imageUrl,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(product.title, style: AppTextStyles.titleLarge),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(priceText, style: AppTextStyles.priceLarge),
                    SizedBox(width: 8.w),
                    Text(
                      'per item',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text('Description', style: AppTextStyles.subtitle),
                SizedBox(height: 6.h),
                Text(description, style: AppTextStyles.description),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text('Quantity', style: AppTextStyles.subtitle),
                      const Spacer(),
                      _QuantityButton(
                        icon: Icons.remove,
                        onTap: quantity > 1
                            ? () => provider.decrementQuantity(product.id)
                            : null,
                      ),
                      SizedBox(width: 12.w),
                      Text(quantity.toString(), style: AppTextStyles.title),
                      SizedBox(width: 12.w),
                      _QuantityButton(
                        icon: Icons.add,
                        onTap: () => provider.incrementQuantity(product.id),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Text('Total', style: AppTextStyles.subtitle),
                    const Spacer(),
                    Text(totalPrice, style: AppTextStyles.priceLarge),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, this.onTap});

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
