import 'package:salonguru/data/sources/products_api_base.dart';
import 'package:salonguru/data/sources/products_api_mock.dart';
import 'package:salonguru/di/shared_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setupMockDependencies(SharedPreferences sharedPreferences) {
  sl.registerLazySingleton<ProductsApiBase>(
    ProductsApiMock.new,
  );
  registerSharedDependencies(sharedPreferences);
}
