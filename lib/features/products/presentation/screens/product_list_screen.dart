import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../../app_router.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/app_message_view.dart';
import '../../../../core/widgets/app_snackbar.dart';
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
  DateTime? _lastBackPressedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleExitAttempt(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80.h,
          elevation: 0,
          titleSpacing: 16.w,
          title: Selector<ProductProvider, int>(
            selector: (_, provider) => provider.products.length,
            builder: (context, productsCount, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Linked Gates', style: AppTextStyles.titleLarge),
                  SizedBox(height: 4.h),
                  Text(
                    '$productsCount products available',
                    style: AppTextStyles.caption,
                  ),
                ],
              );
            },
          ),
          actions: [
            Selector<ProductProvider, ProductLayout>(
              selector: (_, provider) => provider.layout,
              builder: (context, layout, _) {
                return _AppBarActionButton(
                  icon: layout == ProductLayout.grid
                      ? Icons.view_list_rounded
                      : Icons.grid_view_rounded,
                  onTap: () {
                    context.read<ProductProvider>().toggleLayout();
                  },
                );
              },
            ),
            SizedBox(width: 8.w),
            Selector<CartProvider, int>(
              selector: (_, cart) => cart.totalItems,
              builder: (context, count, _) {
                return _AppBarActionButton(
                  icon: Icons.shopping_bag_outlined,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.cart,
                      arguments: CartArgs(
                        cartProvider: context.read<CartProvider>(),
                      ),
                    );
                  },
                  badge: count > 0 ? _CartBadge(count: count) : null,
                );
              },
            ),
            SizedBox(width: 16.w),
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
      ),
    );
  }

  void _handleExitAttempt(BuildContext context) {
    final now = DateTime.now();
    final shouldExit =
        _lastBackPressedAt != null &&
        now.difference(_lastBackPressedAt!) < const Duration(seconds: 2);

    if (shouldExit) {
      SystemNavigator.pop();
      return;
    }

    _lastBackPressedAt = now;

    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: 'Press back again to exit',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 14.sp,
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

class _AppBarActionButton extends StatelessWidget {
  const _AppBarActionButton({
    required this.icon,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: SizedBox(
          width: 42.w,
          height: 42.w,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Icon(icon, color: AppColors.textPrimary),
              if (badge != null) Positioned(top: -4, right: -6, child: badge!),
            ],
          ),
        ),
      ),
    );
  }
}

void _showCartSnackBar(BuildContext context) {
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
