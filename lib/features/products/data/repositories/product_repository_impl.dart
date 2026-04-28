import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../data_sources/product_local_data_source.dart';
import '../data_sources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;

  @override
  Future<List<ProductEntity>> getProducts() async {
    final cachedModels = await _localDataSource.getCachedProducts();
    if (cachedModels.isNotEmpty) {
      return cachedModels.map((model) => model.toEntity()).toList();
    }

    try {
      final models = await _remoteDataSource.getProducts();
      await _localDataSource.cacheProducts(models);
      return models.map((model) => model.toEntity()).toList();
    } on ServerException catch (error) {
      throw ServerFailure(error.message);
    }
  }
}
