import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../app_router.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../cart/domain/entities/cart_size.dart';
import '../../../cart/presentation/provider/cart_provider.dart';
import '../../domain/entities/product_entity.dart';
import '../provider/product_provider.dart';
import 'product_list_item.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({super.key, required this.products});

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: products.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final product = products[index];
        return Selector<ProductProvider, ListCardState>(
          selector: (_, provider) => ListCardState(
            isFavorite: provider.isFavorite(product.id),
            priceText: provider.getFormattedPrice(product),
            description: provider.getDescription(product),
            size: provider.getSelectedSize(product.id),
          ),
          builder: (context, state, _) {
            return Selector<CartProvider, int>(
              selector: (_, cart) => cart.quantityFor(product.id, state.size),
              builder: (context, quantity, _) {
                return ProductListItem(
                  product: product,
                  isFavorite: state.isFavorite,
                  priceText: state.priceText,
                  description: state.description,
                  selectedSize: state.size,
                  quantity: quantity,
                  onSizeSelected: (size) {
                    context.read<ProductProvider>().setSelectedSize(product.id, size);
                  },
                  onFavoriteTap: () {
                    context.read<ProductProvider>().toggleFavorite(product.id);
                  },
                  onIncrease: () {
                    final provider = context.read<ProductProvider>();
                    final cart = context.read<CartProvider>();
                    final price = provider.getDisplayPrice(product);
                    if (quantity == 0) {
                      cart.addItem(
                        product: product,
                        price: price,
                        size: state.size,
                      );
                      showCartSnackBar(context);
                    } else {
                      cart.increase(product.id, state.size);
                    }
                  },
                  onDecrease: quantity > 0
                      ? () {
                          context.read<CartProvider>().decrease(product.id, state.size);
                        }
                      : null,
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
      },
    );
  }
}

class ListCardState {
  const ListCardState({
    required this.isFavorite,
    required this.priceText,
    required this.description,
    required this.size,
  });

  final bool isFavorite;
  final String priceText;
  final String description;
  final CartSize size;
}

void showCartSnackBar(BuildContext context) {
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
