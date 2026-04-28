import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';
import 'product_api_service.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl(this._apiService);

  final ProductApiService _apiService;

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      return await _apiService.getProducts();
    } on DioException catch (error) {
      throw ServerException.fromDio(error);
    }
  }
}
