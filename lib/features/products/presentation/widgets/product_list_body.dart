import 'package:flutter/material.dart';

import '../../../../core/widgets/app_message_view.dart';
import '../provider/product_provider.dart';
import 'product_shimmer.dart';
import 'products_grid.dart';
import 'products_list.dart';

class ProductListBody extends StatelessWidget {
  const ProductListBody({super.key, required this.provider});

  final ProductProvider provider;

  @override
  Widget build(BuildContext context) {
    const crossAxisCount = 2;
    switch (provider.status) {
      case ProductStatus.initial:
      case ProductStatus.loading:
        return ProductShimmerList(
          crossAxisCount: crossAxisCount,
          layout: provider.layout,
        );
      case ProductStatus.error:
        return AppMessageView(
          message: provider.errorMessage ?? 'Failed to load products.',
          icon: Icons.error_outline,
        );
      case ProductStatus.success:
        final products = provider.products;
        if (products.isEmpty) {
          return const AppMessageView(
            message: 'No products found.',
            icon: Icons.inventory_2_outlined,
          );
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.02, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: provider.layout == ProductLayout.grid
              ? ProductsGrid(
                  key: const ValueKey('grid'),
                  products: products,
                  crossAxisCount: crossAxisCount,
                )
              : ProductsList(
                  key: const ValueKey('list'),
                  products: products,
                ),
        );
    }
  }
}
