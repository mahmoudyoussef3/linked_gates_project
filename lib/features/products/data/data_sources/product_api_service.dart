import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/product_model.dart';

part 'product_api_service.g.dart';

@RestApi()
abstract class ProductApiService {
  factory ProductApiService(Dio dio, {String baseUrl}) = _ProductApiService;

  @GET('/products')
  Future<List<ProductModel>> getProducts();
}
