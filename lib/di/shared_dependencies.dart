import 'package:get_it/get_it.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:salonguru/data/repositories/cart_repository_impl.dart';
import 'package:salonguru/data/repositories/products_repository_impl.dart';
import 'package:salonguru/data/sources/cart_local_datasource.dart';
import 'package:salonguru/data/sources/products_api_base.dart';
import 'package:salonguru/domain/repositories/cart_repository.dart';
import 'package:salonguru/domain/repositories/products_repository.dart';
import 'package:salonguru/domain/usecases/add_to_cart_use_case.dart';
import 'package:salonguru/domain/usecases/checkout_use_case.dart';
import 'package:salonguru/domain/usecases/clear_cart_use_case.dart';
import 'package:salonguru/domain/usecases/get_cart_items_use_case.dart';
import 'package:salonguru/domain/usecases/get_products_use_case.dart';
import 'package:salonguru/features/cart/cart_view_model.dart';
import 'package:salonguru/features/products/products_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/storage.dart';

final sl = GetIt.instance;

void registerSharedDependencies(SharedPreferences sharedPreferences) {
  sl
    ..registerLazySingleton<Storage>(
      () => PersistentStorage(sharedPreferences: sharedPreferences),
    )
    ..registerLazySingleton<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(
        storage: sl<Storage>(),
      ),
    )
    ..registerLazySingleton<ProductsRepository>(
      () => ProductsRepositoryImpl(productsApi: sl<ProductsApiBase>()),
    )
    ..registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(localDataSource: sl<CartLocalDataSource>()),
    )
    ..registerFactory(
      () => AddToCartUseCase(cartRepository: sl<CartRepository>()),
    )
    ..registerFactory(
      () => CheckoutUseCase(
        cartRepository: sl<CartRepository>(),
        productRepository: sl<ProductsRepository>(),
      ),
    )
    ..registerFactory(
      () => ClearCartUseCase(cartRepository: sl<CartRepository>()),
    )
    ..registerFactory(
      () => GetCartItemsUseCase(cartRepository: sl<CartRepository>()),
    )
    ..registerFactory(
      () => GetProductsUseCase(productsRepository: sl<ProductsRepository>()),
    )
    ..registerCachedFactory(
      () => ProductsViewModel(
        getProductsUseCase: sl(),
        addToCartUseCase: sl(),
        getCartItemsUseCase: sl(),
      ),
    )
    ..registerCachedFactory(
      () => CartViewModel(
        cartItemsUseCase: sl(),
        checkoutUseCase: sl(),
        clearUseCase: sl(),
        addToCartUseCase: sl(),
      ),
    );
}
