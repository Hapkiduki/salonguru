import 'package:dio/dio.dart';

extension DioExtension on Dio {
  void addInterceptor(Interceptor interceptor) {
    interceptors.add(interceptor);
  }
}
