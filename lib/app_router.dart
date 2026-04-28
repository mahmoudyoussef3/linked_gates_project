import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/widgets/app_message_view.dart';
import 'features/products/domain/entities/product_entity.dart';
import 'features/products/domain/use_cases/get_products_usecase.dart';
import 'features/products/presentation/provider/product_provider.dart';
import 'features/products/presentation/screens/product_detail_screen.dart';
import 'features/products/presentation/screens/product_list_screen.dart';

class AppRoutes {
  static const String products = '/products';
  static const String productDetails = '/products/details';
}

class ProductDetailsArgs {
  const ProductDetailsArgs({
    required this.product,
    required this.provider,
  });

  final ProductEntity product;
  final ProductProvider provider;
}

class AppRouter {
  AppRouter(this._getProductsUseCase);

  final GetProductsUseCase _getProductsUseCase;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.products:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ProductProvider(_getProductsUseCase),
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
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProvider.value(
            value: args.provider,
            child: ProductDetailScreen(product: args.product),
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
}
