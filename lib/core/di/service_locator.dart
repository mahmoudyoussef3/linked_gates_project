import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../app_router.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/use_cases/add_item_to_cart_usecase.dart';
import '../../features/cart/domain/use_cases/clear_cart_usecase.dart';
import '../../features/cart/domain/use_cases/get_cart_items_usecase.dart';
import '../../features/cart/domain/use_cases/get_cart_totals_usecase.dart';
import '../../features/cart/domain/use_cases/manage_cart_item_quantity_usecase.dart';
import '../../features/cart/domain/use_cases/remove_cart_item_usecase.dart';
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
  getIt.registerLazySingleton<CartRepository>(() => CartRepositoryImpl());
  getIt.registerLazySingleton<AddItemToCartUseCase>(
    () => AddItemToCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<GetCartItemsUseCase>(
    () => GetCartItemsUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<GetCartTotalsUseCase>(
    () => GetCartTotalsUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<ManageCartItemQuantityUseCase>(
    () => ManageCartItemQuantityUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<RemoveCartItemUseCase>(
    () => RemoveCartItemUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<ClearCartUseCase>(
    () => ClearCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerFactory<AppRouter>(
    () => AppRouter(
      getIt<GetProductsUseCase>(),
      addItemToCartUseCase: getIt<AddItemToCartUseCase>(),
      getCartItemsUseCase: getIt<GetCartItemsUseCase>(),
      getCartTotalsUseCase: getIt<GetCartTotalsUseCase>(),
      manageCartItemQuantityUseCase: getIt<ManageCartItemQuantityUseCase>(),
      removeCartItemUseCase: getIt<RemoveCartItemUseCase>(),
      clearCartUseCase: getIt<ClearCartUseCase>(),
    ),
  );
}
