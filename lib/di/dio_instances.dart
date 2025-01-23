import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:network/network.dart';
import 'package:salonguru/di/shared_dependencies.dart';
import 'package:salonguru/request_data_provider_impl.dart';

void setupDioInstances() {
  sl.registerLazySingleton<Dio>(
    () {
      final dioBuilder = DioBuilder(
        'https://g93902zutc.execute-api.eu-central-1.amazonaws.com/prod',
        RequestDataProviderImpl(),
      ).addLogInterceptor().addInterceptor(
            CurlLoggerDioInterceptor(printOnSuccess: true),
          );
      return dioBuilder.build();
    },
  );
}
