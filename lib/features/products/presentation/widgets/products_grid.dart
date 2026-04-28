import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../app_router.dart';
import '../../../cart/presentation/provider/cart_provider.dart';
import '../../domain/entities/product_entity.dart';
import '../provider/product_provider.dart';
import 'product_grid_item.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    super.key,
    required this.products,
    required this.crossAxisCount,
  });

  final List<ProductEntity> products;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 0.78,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Selector<ProductProvider, GridCardState>(
          selector: (_, provider) => GridCardState(
            isFavorite: provider.isFavorite(product.id),
            priceText: provider.getFormattedPrice(product),
          ),
          builder: (context, state, _) {
            return ProductGridItem(
              product: product,
              index: index,
              isFavorite: state.isFavorite,
              priceText: state.priceText,
              onFavoriteTap: () {
                context.read<ProductProvider>().toggleFavorite(product.id);
              },
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.productDetails,
                  arguments: ProductDetailsArgs(
                    product: product,
                    productProvider: context.read<ProductProvider>(),
                    cartProvider: context.read<CartProvider>(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class GridCardState {
  const GridCardState({
    required this.isFavorite,
    required this.priceText,
  });

  final bool isFavorite;
  final String priceText;
}
