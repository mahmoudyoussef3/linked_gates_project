import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../../../core/extensions/price_extensions.dart';
import '../../domain/entities/product_entity.dart';

class CartItem {
  CartItem({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
  });

  final int productId;
  final String title;
  final String imageUrl;
  final double unitPrice;
  int quantity;

  double get totalPrice => unitPrice * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  UnmodifiableListView<CartItem> get items =>
      UnmodifiableListView(_items.values);

  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.values.fold(0, (sum, item) => sum + item.totalPrice);

  String get formattedTotalPrice => totalPrice.formatCurrency();

  int quantityFor(int productId) => _items[productId]?.quantity ?? 0;

  void addItem({
    required ProductEntity product,
    required double price,
    int quantity = 1,
  }) {
    final existing = _items[product.id];
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _items[product.id] = CartItem(
        productId: product.id,
        title: product.title,
        imageUrl: product.imageUrl,
        unitPrice: price,
        quantity: quantity,
      );
    }
    notifyListeners();
  }

  void increase(int productId) {
    final item = _items[productId];
    if (item == null) return;
    item.quantity += 1;
    notifyListeners();
  }

  void decrease(int productId) {
    final item = _items[productId];
    if (item == null) return;
    if (item.quantity <= 1) {
      _items.remove(productId);
    } else {
      item.quantity -= 1;
    }
    notifyListeners();
  }

  void remove(int productId) {
    if (_items.remove(productId) != null) {
      notifyListeners();
    }
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
