import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../app_router.dart';
import '../../../../core/widgets/app_message_view.dart';
import '../provider/cart_provider.dart';
import '../provider/product_provider.dart';
import '../widgets/product_grid_item.dart';
import '../widgets/product_list_item.dart';
import '../widgets/product_shimmer.dart';
import '../../domain/entities/product_entity.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Selector<ProductProvider, ProductLayout>(
            selector: (_, provider) => provider.layout,
            builder: (context, layout, _) {
              return IconButton(
                onPressed: () {
                  context.read<ProductProvider>().toggleLayout();
                },
                icon: Icon(
                  layout == ProductLayout.grid
                      ? Icons.view_list_rounded
                      : Icons.grid_view_rounded,
                ),
              );
            },
          ),
          Selector<CartProvider, int>(
            selector: (_, cart) => cart.totalItems,
            builder: (context, count, _) {
              return IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.cart,
                    arguments: CartArgs(
                      cartProvider: context.read<CartProvider>(),
                    ),
                  );
                },
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_bag_outlined),
                    if (count > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: _CartBadge(count: count),
                      ),
                  ],
                ),
              );
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
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
                    ? _ProductsGrid(
                        key: const ValueKey('grid'),
                        products: products,
                        crossAxisCount: crossAxisCount,
                      )
                    : _ProductsList(
                        key: const ValueKey('list'),
                        products: products,
                      ),
              );
          }
        },
      ),
    );
  }
}

class _ProductsGrid extends StatelessWidget {
  const _ProductsGrid({
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
        return Selector<ProductProvider, _GridCardState>(
          selector: (_, provider) => _GridCardState(
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

class _ProductsList extends StatelessWidget {
  const _ProductsList({super.key, required this.products});

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: products.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final product = products[index];
        return Selector<ProductProvider, _ListCardState>(
          selector: (_, provider) => _ListCardState(
            isFavorite: provider.isFavorite(product.id),
            priceText: provider.getFormattedPrice(product),
            description: provider.getDescription(product),
            size: provider.getSelectedSize(product.id),
          ),
          builder: (context, state, _) {
            return Selector<CartProvider, int>(
              selector: (_, cart) =>
                  cart.quantityFor(product.id, state.size),
              builder: (context, quantity, _) {
                return ProductListItem(
                  product: product,
                  isFavorite: state.isFavorite,
                  priceText: state.priceText,
                  description: state.description,
                  selectedSize: state.size,
                  quantity: quantity,
                  onSizeSelected: (size) {
                    context
                        .read<ProductProvider>()
                        .setSelectedSize(product.id, size);
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
                      _showCartSnackBar(context);
                    } else {
                      cart.increase(product.id, state.size);
                    }
                  },
                  onDecrease: quantity > 0
                      ? () {
                          context
                              .read<CartProvider>()
                              .decrease(product.id, state.size);
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

class _GridCardState {
  const _GridCardState({
    required this.isFavorite,
    required this.priceText,
  });

  final bool isFavorite;
  final String priceText;
}

class _ListCardState {
  const _ListCardState({
    required this.isFavorite,
    required this.priceText,
    required this.description,
    required this.size,
  });

  final bool isFavorite;
  final String priceText;
  final String description;
  final ProductSize size;
}

class _CartBadge extends StatelessWidget {
  const _CartBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: Colors.white, fontSize: 10.sp),
      ),
    );
  }
}

void _showCartSnackBar(BuildContext context) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: const Text('Added to cart'),
      action: SnackBarAction(
        label: 'View cart',
        onPressed: () {
          Navigator.of(context).pushNamed(
            AppRoutes.cart,
            arguments: CartArgs(
              cartProvider: context.read<CartProvider>(),
            ),
          );
        },
      ),
    ),
  );
}
