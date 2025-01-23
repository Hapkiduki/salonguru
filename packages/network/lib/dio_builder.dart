import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:network/config/connectivity_timeout.dart';
import 'package:network/config/request_data.dart';
import 'package:network/interceptors/headers_interceptor.dart';

class DioBuilder {
  DioBuilder(this._baseUrl, this._requestDataProvider) {
    _interceptors.add(HeadersInterceptor(_requestDataProvider));
  }

  final String _baseUrl;
  final RequestData _requestDataProvider;

  ConnectivityTimeout _timeouts = const ConnectivityTimeout(
    receive: 15,
    connect: 30,
    send: 45,
  );
  Http2Adapter? _http2adapter;
  Transformer? _transformer;
  final List<Interceptor> _interceptors = [];

  // Method to add custom timeouts
  DioBuilder setTimeouts(ConnectivityTimeout timeouts) {
    _timeouts = timeouts;
    return this;
  }

  // Method to add a log interceptor
  DioBuilder addLogInterceptor() {
    _interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) {
          if (kDebugMode) {
            debugPrint(object.toString());
          }
        }, // In the future use a logger
      ),
    );
    return this;
  }

  // Method to add a custom interceptor
  DioBuilder addInterceptor(Interceptor interceptor) {
    _interceptors.add(interceptor);
    return this;
  }

  // Method to add a custom transformer
  DioBuilder addTransformer(Transformer transformer) {
    _transformer = transformer;
    return this;
  }

  // Build method to return the configured Dio instance
  Dio build() {
    // Set base options for Dio
    final options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: _timeouts.connectDuration, // Connection timeout
      receiveTimeout: _timeouts.receiveDuration, // Read timeout
      sendTimeout: _timeouts.sendDuration, // Send timeout
    );

    final dio = Dio(options);
    dio.interceptors.addAll(_interceptors);
    dio
      ..transformer = _transformer ?? dio.transformer
      ..httpClientAdapter = _http2adapter ?? dio.httpClientAdapter;

    return dio;
  }
}
