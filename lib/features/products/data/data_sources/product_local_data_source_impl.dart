import 'package:hive/hive.dart';

import '../../../../core/utils/constants.dart';
import '../models/product_model.dart';
import 'product_local_data_source.dart';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  ProductLocalDataSourceImpl(this._box);

  final Box _box;

  static const String _productsKey = 'products_cache';
  static const String _cachedAtKey = 'products_cache_time';

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final cachedAtMillis = _box.get(_cachedAtKey) as int?;
    if (cachedAtMillis == null) {
      return [];
    }

    final cachedAt = DateTime.fromMillisecondsSinceEpoch(cachedAtMillis);
    final isValid =
        DateTime.now().difference(cachedAt) <=
        AppConstants.productsCacheDuration;
    if (!isValid) {
      return [];
    }

    final raw = _box.get(_productsKey);
    if (raw is! List) {
      return [];
    }

    return raw
        .whereType<Map>()
        .map(
          (item) =>
              ProductModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final payload = products.map((model) => model.toJson()).toList();
    await _box.put(_productsKey, payload);
    await _box.put(_cachedAtKey, DateTime.now().millisecondsSinceEpoch);
  }
}
