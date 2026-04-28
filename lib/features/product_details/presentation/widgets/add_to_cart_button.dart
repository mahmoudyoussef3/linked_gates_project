import 'package:flutter/material.dart';

import '../../../cart/presentation/provider/cart_provider.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/provider/product_provider.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.product,
    required this.quantity,
    required this.selectedSize,
    required this.provider,
    required this.cart,
  });

  final ProductEntity product;
  final int quantity;
  final dynamic selectedSize;
  final ProductProvider provider;
  final CartProvider cart;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          cart.addItem(
            product: product,
            price: provider.getDisplayPrice(product),
            size: selectedSize,
            quantity: quantity,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to cart')),
          );
        },
        child: const Text('Add to Cart'),
      ),
    );
  }
}