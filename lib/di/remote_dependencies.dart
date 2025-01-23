import 'package:salonguru/data/sources/products_api.dart';
import 'package:salonguru/data/sources/products_api_base.dart';
import 'package:salonguru/di/dio_instances.dart';
import 'package:salonguru/di/shared_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setupDependencies(SharedPreferences sharedPreferences) {
  setupDioInstances();
  sl.registerLazySingleton<ProductsApiBase>(
    () => ProductsApi(dioInstance: sl()),
  );
  registerSharedDependencies(sharedPreferences);
}
