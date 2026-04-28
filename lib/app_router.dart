import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/widgets/app_message_view.dart';
import 'features/products/domain/entities/product_entity.dart';
import 'features/products/domain/use_cases/get_products_usecase.dart';
import 'features/products/presentation/provider/cart_provider.dart';
import 'features/products/presentation/provider/product_provider.dart';
import 'features/cart/presentation/screens/cart_screen.dart';
import 'features/products/presentation/screens/product_details_screen.dart';
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
  AppRouter(this._getProductsUseCase);

  final GetProductsUseCase _getProductsUseCase;

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
              ChangeNotifierProvider(create: (_) => CartProvider()),
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
      pageBuilder: (_, __, ___) => page,
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
