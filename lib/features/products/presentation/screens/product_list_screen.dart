import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linked_gates_project/core/widgets/functions.dart';
import 'package:provider/provider.dart';

import '../../../../app_router.dart';
import '../../../cart/presentation/provider/cart_provider.dart';
import '../provider/product_provider.dart';
import '../widgets/product_list_app_bar_action.dart';
import '../widgets/product_list_app_bar_title.dart';
import '../widgets/product_list_body.dart';

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
              return ProductListAppBarTitle(productsCount: productsCount);
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
            return ProductListBody(provider: provider);
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
