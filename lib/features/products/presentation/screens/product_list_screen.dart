import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linked_gates_project/core/widgets/functions.dart';
import 'package:provider/provider.dart';

import '../../../../app_router.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/app_message_view.dart';
import '../../../cart/presentation/provider/cart_provider.dart';
import '../provider/product_provider.dart';
import '../widgets/product_list_app_bar_action.dart';
import '../widgets/products_grid.dart';
import '../widgets/products_list.dart';
import '../widgets/product_shimmer.dart';

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
          handleExitAttempt(context);
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
                return ProductListAppBarAction(
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
                return ProductListAppBarAction(
                  icon: Icons.shopping_bag_outlined,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.cart,
                      arguments: CartArgs(
                        cartProvider: context.read<CartProvider>(),
                      ),
                    );
                  },
                  badge: count > 0 ? CartBadge(count: count) : null,
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
          },
        ),
      ),
    );
  }

  void handleExitAttempt(BuildContext context) {
    final now = DateTime.now();
    final shouldExit =
        _lastBackPressedAt != null &&
        now.difference(_lastBackPressedAt!) < const Duration(seconds: 2);

    if (shouldExit) {
      SystemNavigator.pop();
      return;
    }

    _lastBackPressedAt = now;

    showToast(message: 'Press back again to exit');
  }
}
