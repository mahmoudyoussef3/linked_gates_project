import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../app_router.dart';
import '../../features/products/data/data_sources/product_local_data_source.dart';
import '../../features/products/data/data_sources/product_local_data_source_impl.dart';
import '../../features/products/data/data_sources/product_api_service.dart';
import '../../features/products/data/data_sources/product_remote_data_source.dart';
import '../../features/products/data/data_sources/product_remote_data_source_impl.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/use_cases/get_products_usecase.dart';
import '../network/dio_client.dart';
import '../utils/constants.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  await Hive.initFlutter();
  final productsBox = await Hive.openBox(AppConstants.productsCacheBox);
  getIt.registerSingleton<Box>(productsBox);
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<ProductApiService>(
    () => ProductApiService(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(getIt<ProductApiService>()),
  );
  getIt.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(getIt<Box>()),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      getIt<ProductRemoteDataSource>(),
      getIt<ProductLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(getIt<ProductRepository>()),
  );
  getIt.registerFactory<AppRouter>(
    () => AppRouter(getIt<GetProductsUseCase>()),
  );
}
