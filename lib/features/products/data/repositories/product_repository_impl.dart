
import 'package:linked_gates_project/core/error/exceptions.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../data_sources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._remoteDataSource);

  final ProductRemoteDataSource _remoteDataSource;

  @override
  Future<List<ProductEntity>> getProducts() async {
  

    try {
      final models = await _remoteDataSource.getProducts();
      return models.map((model) => model.toEntity()).toList();
    } catch (error) {
      throw (error is AppException) ? error : AppException('Failed to load products.');
    }
  }
}
