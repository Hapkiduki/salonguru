import 'package:dio/dio.dart';
import 'package:network/config/request_data.dart';

/// {@template headers_interceptor}
/// Interceptor to add common custom headers to each request.
///
/// This interceptor will add headers defined in the app
/// to the request. These can be customized as needed.
/// {@endtemplate}
class HeadersInterceptor extends Interceptor {
  /// {@macro connectivity_timeout}
  /// Constructs an instance of `HeadersInterceptor` with
  /// the provided [RequestData].
  const HeadersInterceptor(this._requestDataProvider);

  /// Provides the global headers for network requests.
  final RequestData _requestDataProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Asynchronously obtain the headers
    final globalHeaders = await _requestDataProvider.headers;

    // Overwrite with the request-specific headers if they exist
    options.headers.forEach((key, value) {
      globalHeaders[key] = value as String;
    });

    // Set the resulting headers on the request
    options.headers = globalHeaders;

    handler.next(options);
  }
}
