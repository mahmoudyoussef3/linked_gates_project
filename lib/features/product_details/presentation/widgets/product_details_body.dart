import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linked_gates_project/features/product_details/presentation/widgets/product_details_widgets.dart';
import 'package:linked_gates_project/features/product_details/presentation/widgets/product_img.dart';
import 'package:linked_gates_project/features/product_details/presentation/widgets/product_totsl_price.dart';

import '../../../cart/presentation/provider/cart_provider.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/provider/product_provider.dart';

import 'product_title.dart';
import 'product_price_quantity.dart';
import 'product_size_section.dart';
import 'product_description.dart';
import 'add_to_cart_button.dart';

class ProductBody extends StatelessWidget {
  const ProductBody({
    super.key,
    required this.product,
    required this.provider,
    required this.cart,
  });

  final ProductEntity product;
  final ProductProvider provider;
  final CartProvider cart;

  @override
  Widget build(BuildContext context) {
    final priceText = provider.getFormattedPrice(product);
    final description = provider.getDescription(product);
    final quantity = provider.getQuantity(product.id);
    final totalPrice = provider.getFormattedTotalPrice(product);
    final selectedSize = provider.getSelectedSize(product.id);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImage(product: product),
          SizedBox(height: 20.h),

          ProductTitle(product: product),
          SizedBox(height: 8.h),

          ProductPriceQuantity(
            priceText: priceText,
            quantity: quantity,
            onIncrease: () => provider.incrementQuantity(product.id),
            onDecrease: quantity > 1
                ? () => provider.decrementQuantity(product.id)
                : null,
          ),

          SizedBox(height: 16.h),
          const SectionDivider(),
          SizedBox(height: 12.h),

          ProductSizeSection(
            productId: product.id,
            selectedSize: selectedSize,
            provider: provider,
          ),

          SizedBox(height: 20.h),
          const SectionDivider(),
          SizedBox(height: 12.h),

          ProductDescription(description: description),

          SizedBox(height: 20.h),
          const SectionDivider(),
          SizedBox(height: 12.h),

          ProductTotalPrice(totalPrice: totalPrice),

          SizedBox(height: 16.h),

          AddToCartButton(
            product: product,
            quantity: quantity,
            selectedSize: selectedSize,
            provider: provider,
            cart: cart,
          ),
        ],
      ),
    );
  }
}