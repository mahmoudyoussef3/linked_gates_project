// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:linked_gates_project/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:linked_gates_project/features/cart/domain/use_cases/add_item_to_cart_usecase.dart';
import 'package:linked_gates_project/features/cart/domain/use_cases/clear_cart_usecase.dart';
import 'package:linked_gates_project/features/cart/domain/use_cases/get_cart_items_usecase.dart';
import 'package:linked_gates_project/features/cart/domain/use_cases/get_cart_totals_usecase.dart';
import 'package:linked_gates_project/features/cart/domain/use_cases/manage_cart_item_quantity_usecase.dart';
import 'package:linked_gates_project/features/cart/domain/use_cases/remove_cart_item_usecase.dart';
import 'package:linked_gates_project/features/cart/presentation/provider/cart_provider.dart';
import 'package:linked_gates_project/features/products/domain/entities/product_entity.dart';
import 'package:linked_gates_project/features/products/domain/repositories/product_repository.dart';
import 'package:linked_gates_project/features/products/domain/use_cases/get_products_usecase.dart';
import 'package:linked_gates_project/features/products/presentation/provider/product_provider.dart';
import 'package:linked_gates_project/features/products/presentation/screens/product_list_screen.dart';

class FakeProductRepository implements ProductRepository {
  @override
  Future<List<ProductEntity>> getProducts() async {
    return const [
      ProductEntity(id: 1, title: 'Test Product', price: 10, imageUrl: ''),
    ];
  }
}

void main() {
  testWidgets('Product list screen renders products', (
    WidgetTester tester,
  ) async {
    final repository = FakeProductRepository();
    final useCase = GetProductsUseCase(repository);
    final cartRepository = CartRepositoryImpl();
    final cartProvider = CartProvider(
      addItemToCartUseCase: AddItemToCartUseCase(cartRepository),
      getCartItemsUseCase: GetCartItemsUseCase(cartRepository),
      getCartTotalsUseCase: GetCartTotalsUseCase(cartRepository),
      manageCartItemQuantityUseCase: ManageCartItemQuantityUseCase(
        cartRepository,
      ),
      removeCartItemUseCase: RemoveCartItemUseCase(cartRepository),
      clearCartUseCase: ClearCartUseCase(cartRepository),
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ProductProvider(useCase)),
            ChangeNotifierProvider.value(value: cartProvider),
          ],
          child: const MaterialApp(home: ProductListScreen()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Linked Gates'), findsOneWidget);
    expect(find.text('Test Product'), findsOneWidget);
  });
}
