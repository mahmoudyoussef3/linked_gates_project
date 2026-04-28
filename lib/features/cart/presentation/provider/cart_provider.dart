import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../../../core/extensions/price_extensions.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../../cart/domain/entities/cart_size.dart';
import '../../../cart/domain/use_cases/add_item_to_cart_usecase.dart';
import '../../../cart/domain/use_cases/clear_cart_usecase.dart';
import '../../../cart/domain/use_cases/get_cart_items_usecase.dart';
import '../../../cart/domain/use_cases/get_cart_totals_usecase.dart';
import '../../../cart/domain/use_cases/manage_cart_item_quantity_usecase.dart';
import '../../../cart/domain/use_cases/remove_cart_item_usecase.dart';
import '../../../products/domain/entities/product_entity.dart';

class CartProvider extends ChangeNotifier {
  CartProvider({
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

  final AddItemToCartUseCase _addItemToCartUseCase;
  final GetCartItemsUseCase _getCartItemsUseCase;
  final GetCartTotalsUseCase _getCartTotalsUseCase;
  final ManageCartItemQuantityUseCase _manageCartItemQuantityUseCase;
  final RemoveCartItemUseCase _removeCartItemUseCase;
  final ClearCartUseCase _clearCartUseCase;

  UnmodifiableListView<CartItemEntity> get items =>
      UnmodifiableListView(_getCartItemsUseCase());

  int get totalItems => _getCartTotalsUseCase.totalItems();

  double get totalPrice => _getCartTotalsUseCase.totalPrice();

  String get formattedTotalPrice => totalPrice.formatCurrency();

  int quantityFor(int productId, CartSize size) =>
      _manageCartItemQuantityUseCase.quantityFor(productId, size);

  void addItem({
    required ProductEntity product,
    required double price,
    required CartSize size,
    int quantity = 1,
  }) {
    _addItemToCartUseCase(
      product: product,
      price: price,
      size: size,
      quantity: quantity,
    );
    notifyListeners();
  }

  void increase(int productId, CartSize size) {
    _manageCartItemQuantityUseCase.increase(productId, size);
    notifyListeners();
  }

  void decrease(int productId, CartSize size) {
    _manageCartItemQuantityUseCase.decrease(productId, size);
    notifyListeners();
  }

  void remove(int productId, CartSize size) {
    _removeCartItemUseCase(productId, size);
    notifyListeners();
  }

  void clear() {
    _clearCartUseCase();
    notifyListeners();
  }
}
