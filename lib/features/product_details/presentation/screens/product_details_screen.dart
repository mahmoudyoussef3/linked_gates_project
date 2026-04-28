import 'package:flutter/material.dart';
import 'package:linked_gates_project/features/product_details/presentation/widgets/product_details_body.dart';
import 'package:provider/provider.dart';

import '../../../cart/presentation/provider/cart_provider.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/provider/product_provider.dart';

import '../widgets/product_app_bar.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ProductAppBar(),
      body: Consumer2<ProductProvider, CartProvider>(
        builder: (context, provider, cart, _) {
          return ProductBody(
            product: product,
            provider: provider,
            cart: cart,
          );
        },
      ),
    );
  }
}