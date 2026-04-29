import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/widgets/app_message_view.dart';
import 'features/cart/domain/use_cases/add_item_to_cart_usecase.dart';
import 'features/cart/domain/use_cases/clear_cart_usecase.dart';
import 'features/cart/domain/use_cases/get_cart_items_usecase.dart';
import 'features/cart/domain/use_cases/get_cart_totals_usecase.dart';
import 'features/cart/domain/use_cases/manage_cart_item_quantity_usecase.dart';
import 'features/cart/domain/use_cases/remove_cart_item_usecase.dart';
import 'features/cart/presentation/provider/cart_provider.dart';
import 'features/products/domain/entities/product_entity.dart';
import 'features/products/domain/use_cases/get_products_usecase.dart';
import 'features/products/presentation/provider/product_provider.dart';
import 'features/cart/presentation/screens/cart_screen.dart';
import 'features/product_details/presentation/screens/product_details_screen.dart';
import 'features/products/presentation/screens/product_list_screen.dart';

class AppRoutes {
  static const String products = '/products';
  static const String productDetails = '/products/details';
  static const String cart = '/cart';
}

class ProductDetailsArgs {
  const ProductDetailsArgs({
    required this.product,
    required this.productProvider,
    required this.cartProvider,
  });

  final ProductEntity product;
  final ProductProvider productProvider;
  final CartProvider cartProvider;
}

class CartArgs {
  const CartArgs({required this.cartProvider});

  final CartProvider cartProvider;
}

class AppRouter {
  AppRouter(
    this._getProductsUseCase, {
    required AddItemToCartUseCase addItemToCartUseCase,
    required GetCartItemsUseCase getCartItemsUseCase,
    required GetCartTotalsUseCase getCartTotalsUseCase,
    required ManageCartItemQuantityUseCase manageCartItemQuantityUseCase,
    required RemoveCartItemUseCase removeCartItemUseCase,
    required ClearCartUseCase clearCartUseCase,
  }) : _addItemToCartUseCase = addItemToCartUseCase,
       _getCartItemsUseCase = getCartItemsUseCase,
       _getCartTotalsUseCase = getCartTotalsUseCase,
       _manageCartItemQuantityUseCase = manageCartItemQuantityUseCase,
       _removeCartItemUseCase = removeCartItemUseCase,
       _clearCartUseCase = clearCartUseCase;

  final GetProductsUseCase _getProductsUseCase;
  final AddItemToCartUseCase _addItemToCartUseCase;
  final GetCartItemsUseCase _getCartItemsUseCase;
  final GetCartTotalsUseCase _getCartTotalsUseCase;
  final ManageCartItemQuantityUseCase _manageCartItemQuantityUseCase;
  final RemoveCartItemUseCase _removeCartItemUseCase;
  final ClearCartUseCase _clearCartUseCase;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.products:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => ProductProvider(_getProductsUseCase),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(
                  addItemToCartUseCase: _addItemToCartUseCase,
                  getCartItemsUseCase: _getCartItemsUseCase,
                  getCartTotalsUseCase: _getCartTotalsUseCase,
                  manageCartItemQuantityUseCase: _manageCartItemQuantityUseCase,
                  removeCartItemUseCase: _removeCartItemUseCase,
                  clearCartUseCase: _clearCartUseCase,
                ),
              ),
            ],
            child: const ProductListScreen(),
          ),
        );
      case AppRoutes.productDetails:
        final args = settings.arguments;
        if (args is! ProductDetailsArgs) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const Scaffold(
              body: AppMessageView(message: 'Invalid product details.'),
            ),
          );
        }
        return _buildPageRoute(
          settings: settings,
          page: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: args.productProvider),
              ChangeNotifierProvider.value(value: args.cartProvider),
            ],
            child: ProductDetailScreen(product: args.product),
          ),
        );
      case AppRoutes.cart:
        final args = settings.arguments;
        if (args is! CartArgs) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const Scaffold(
              body: AppMessageView(message: 'Invalid cart details.'),
            ),
          );
        }
        return _buildPageRoute(
          settings: settings,
          page: ChangeNotifierProvider.value(
            value: args.cartProvider,
            child: const CartScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }

  PageRouteBuilder<dynamic> _buildPageRoute({
    required RouteSettings settings,
    required Widget page,
  }) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        final offsetTween = Tween<Offset>(
          begin: const Offset(0.08, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(offsetTween),
            child: child,
          ),
        );
      },
    );
  }
}
