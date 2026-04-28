import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../../../core/extensions/price_extensions.dart';
import '../../domain/entities/product_entity.dart';
import 'product_provider.dart';

class CartItem {
  CartItem({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    required this.size,
  });

  final int productId;
  final String title;
  final String imageUrl;
  final double unitPrice;
  int quantity;
  final ProductSize size;

  double get totalPrice => unitPrice * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  UnmodifiableListView<CartItem> get items =>
      UnmodifiableListView(_items.values);

  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.values.fold(0, (sum, item) => sum + item.totalPrice);

  String get formattedTotalPrice => totalPrice.formatCurrency();

  int quantityFor(int productId, ProductSize size) =>
      _items[_key(productId, size)]?.quantity ?? 0;

  void addItem({
    required ProductEntity product,
    required double price,
    required ProductSize size,
    int quantity = 1,
  }) {
    final key = _key(product.id, size);
    final existing = _items[key];
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _items[key] = CartItem(
        productId: product.id,
        title: product.title,
        imageUrl: product.imageUrl,
        unitPrice: price,
        quantity: quantity,
        size: size,
      );
    }
    notifyListeners();
  }

  void increase(int productId, ProductSize size) {
    final item = _items[_key(productId, size)];
    if (item == null) return;
    item.quantity += 1;
    notifyListeners();
  }

  void decrease(int productId, ProductSize size) {
    final key = _key(productId, size);
    final item = _items[key];
    if (item == null) return;
    if (item.quantity <= 1) {
      _items.remove(key);
    } else {
      item.quantity -= 1;
    }
    notifyListeners();
  }

  void remove(int productId, ProductSize size) {
    if (_items.remove(_key(productId, size)) != null) {
      notifyListeners();
    }
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }

  String _key(int productId, ProductSize size) => '${productId}_${size.name}';
}
