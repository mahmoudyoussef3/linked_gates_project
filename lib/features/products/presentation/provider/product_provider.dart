import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/extensions/price_extensions.dart';
import '../../../../core/utils/fake_data_helper.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/use_cases/get_products_usecase.dart';

enum ProductStatus { initial, loading, success, error }

enum ProductLayout { grid, list }

enum ProductSize { s, m, l }

class ProductProvider extends ChangeNotifier {
  ProductProvider(this._getProductsUseCase);

  final GetProductsUseCase _getProductsUseCase;

  ProductStatus _status = ProductStatus.initial;
  List<ProductEntity> _products = const [];
  String? _errorMessage;
  final Set<int> _favorites = <int>{};
  final Map<int, int> _quantities = <int, int>{};
  final Map<int, double> _displayPrices = <int, double>{};
  final Map<int, String> _descriptions = <int, String>{};
  final Map<int, ProductSize> _sizes = <int, ProductSize>{};
  ProductLayout _layout = ProductLayout.grid;

  ProductStatus get status => _status;
  List<ProductEntity> get products => _products;
  String? get errorMessage => _errorMessage;
  UnmodifiableSetView<int> get favorites => UnmodifiableSetView(_favorites);
  ProductLayout get layout => _layout;

  Future<void> loadProducts() async {
    _status = ProductStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _getProductsUseCase();
      _products = result;
      _warmPresentationData();
      _status = ProductStatus.success;
    } on Failure catch (error) {
      _status = ProductStatus.error;
      _errorMessage = error.message;
    } catch (_) {
      _status = ProductStatus.error;
      _errorMessage = 'Unexpected error occurred.';
    }

    notifyListeners();
  }

  void toggleFavorite(int productId) {
    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
    } else {
      _favorites.add(productId);
    }
    notifyListeners();
  }

  bool isFavorite(int productId) => _favorites.contains(productId);

  void toggleLayout() {
    _layout = _layout == ProductLayout.grid
        ? ProductLayout.list
        : ProductLayout.grid;
    notifyListeners();
  }

  void setLayout(ProductLayout layout) {
    if (_layout == layout) return;
    _layout = layout;
    notifyListeners();
  }

  int getQuantity(int productId) => _quantities[productId] ?? 1;

  ProductSize getSelectedSize(int productId) =>
      _sizes[productId] ?? ProductSize.m;

  void setSelectedSize(int productId, ProductSize size) {
    _sizes[productId] = size;
    notifyListeners();
  }

  String sizeLabel(ProductSize size) {
    switch (size) {
      case ProductSize.s:
        return 'S';
      case ProductSize.m:
        return 'M';
      case ProductSize.l:
        return 'L';
    }
  }

  void incrementQuantity(int productId) {
    _quantities[productId] = getQuantity(productId) + 1;
    notifyListeners();
  }

  void decrementQuantity(int productId) {
    final current = getQuantity(productId);
    if (current > 1) {
      _quantities[productId] = current - 1;
      notifyListeners();
    }
  }

  double getDisplayPrice(ProductEntity product) {
    return _displayPrices.putIfAbsent(
      product.id,
      () => FakeDataHelper.resolvePrice(
        price: product.price,
        seed: product.id,
      ),
    );
  }

  String getFormattedPrice(ProductEntity product) {
    return getDisplayPrice(product).formatCurrency();
  }

  String getDescription(ProductEntity product) {
    return _descriptions.putIfAbsent(
      product.id,
      () => FakeDataHelper.resolveDescription(
        description: product.description,
        title: product.title,
        seed: product.id,
      ),
    );
  }

  double getTotalPrice(ProductEntity product) {
    return getDisplayPrice(product) * getQuantity(product.id);
  }

  String getFormattedTotalPrice(ProductEntity product) {
    return getTotalPrice(product).formatCurrency();
  }

  void _warmPresentationData() {
    for (final product in _products) {
      _quantities.putIfAbsent(product.id, () => 1);
      _sizes.putIfAbsent(product.id, () => ProductSize.m);
      _displayPrices.putIfAbsent(
        product.id,
        () => FakeDataHelper.resolvePrice(
          price: product.price,
          seed: product.id,
        ),
      );
      _descriptions.putIfAbsent(
        product.id,
        () => FakeDataHelper.resolveDescription(
          description: product.description,
          title: product.title,
          seed: product.id,
        ),
      );
    }
  }
}
