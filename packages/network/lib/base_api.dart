import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:network/network.dart';

/// {@template base_api}
/// A base class for interacting with APIs using Dio.
///
/// This class provides common methods for making HTTP requests,
/// handling responses, and processing JSON data efficiently with isolates.
///
/// It simplifies the implementation of GET, POST, PATCH, and DELETE requests
/// without handling headers/timeouts directly (since `DioBuilder` manages those).
/// {@endtemplate}
mixin BaseApi {
  /// The Dio instance used for making HTTP requests.
  ///
  /// This should be initialized in the implementing class.
  Dio get dio;

  /// {@template call_api}
  /// Makes an API call and handles its response.
  ///
  /// [caller] - A future representing the API request.
  /// [mapperFunction] - A function to map the response data to the desired type.
  /// [callBack] - An optional callback invoked with the response status code.
  ///
  /// Returns the mapped response data.
  /// Throws [NetworkException] for network-related errors or timeouts.
  /// {@endtemplate}
  Future<T> callApi<T>(
    Future<Response<dynamic>> caller,
    T Function(dynamic data) mapperFunction, {
    Function? callBack,
  }) async {
    try {
      final response = await caller;
      if (callBack != null) {
        await callBack(response.statusCode);
      }
      return await manageResponse(response, mapperFunction);
    } on DioException catch (dioError) {
      final statusCode = dioError.response?.statusCode;
      if (statusCode != null) {
        throw NetworkException.fromStatusCode(statusCode);
      } else {
        throw const NetworkException(
          message: 'Unknown error',
          statusCode: 0,
          code: 'NETWORK_ERROR',
        );
      }
    } on SocketException {
      throw const NetworkException(
        message: 'No internet connection',
        statusCode: 0,
        code: 'NO_INTERNET',
      );
    } on TimeoutException {
      throw const NetworkException(
        message: 'Request timed out',
        statusCode: 0,
        code: 'TIMEOUT',
      );
    }
  }

  /// {@template manage_response}
  /// Handles the API response and applies the [mapperFunction] to the data.
  ///
  /// [response] - The Dio response object.
  /// [mapperFunction] - A function to map the response data to the desired type.
  ///
  /// If the status code is 2xx, it decodes the body (if needed), and then uses an isolate
  /// to run the [mapperFunction] on the decoded data.
  ///
  /// Returns the mapped response data.
  /// Throws [NetworkException] for unexpected status codes or parsing errors.
  /// {@endtemplate}
  Future<T> manageResponse<T>(
    Response<dynamic> response,
    T Function(dynamic data) mapperFunction,
  ) async {
    final statusCode = response.statusCode ?? 500;
    if (statusCode >= 200 && statusCode < 300) {
      // Decode the body if necessary
      final parsedBody = await getBodyAsync(response.data);

      return (await processJson(
        body: jsonEncode(parsedBody),
        processor: (Map<String, Object?> message) {
          final sendPort = message['sendPort']! as SendPort;
          final rawJson = message['body']! as String;
          try {
            final decoded = json.decode(rawJson);
            final result = mapperFunction(decoded);
            sendPort.send(result);
          } on Exception catch (_) {
            sendPort.send(null);
          }
        },
      )) as T;
    } else {
      throw NetworkException.fromStatusCode(statusCode);
    }
  }

  /// {@template get_body_async}
  /// Parses the response body asynchronously using isolates for efficient processing.
  ///
  /// This method checks if the response body is already a Map or List (which means
  /// it has already been decoded by Dio), or if it is a raw String or byte array
  /// that needs decoding.
  ///
  /// [body] - The response body to parse.
  /// Returns the parsed body as a dynamic object.
  /// {@endtemplate}
  Future<dynamic> getBodyAsync(dynamic body) async {
    // If the body is already a Map or List, no need to decode again.
    if (body is Map || body is List) {
      return body;
    }

    String bodyString;
    if (body is String) {
      bodyString = body;
    } else if (body is List<int>) {
      bodyString = utf8.decode(body);
    } else {
      // If it's neither a String nor a List<int>, return it as is.
      return body;
    }

    // Decode the JSON in an isolate.
    return processJson(
      body: bodyString,
      processor: (Map<String, Object?> message) {
        final sendPort = message['sendPort']! as SendPort;
        final rawBody = message['body']! as String;
        try {
          final decoded = json.decode(rawBody);
          sendPort.send(decoded);
        } on Exception catch (_) {
          // If it fails to decode as JSON, send the raw string
          sendPort.send(rawBody);
        }
      },
    );
  }

  /// {@template process_json}
  /// Processes JSON data in a separate isolate.
  ///
  /// [body] - The JSON string to parse or the data to process.
  /// [processor] - A function to process the JSON data in the isolate.
  ///
  /// Returns the processed result.
  /// {@endtemplate}
  Future<dynamic> processJson({
    required String? body,
    required void Function(Map<String, Object?>) processor,
  }) async {
    final receivePort = ReceivePort();
    Isolate? isolate;
    try {
      isolate = await Isolate.spawn(
        processor,
        <String, Object?>{
          'body': body ?? '',
          'sendPort': receivePort.sendPort,
        },
      );
      return await receivePort.first;
    } finally {
      isolate?.kill();
    }
  }

  /// {@template get_api}
  /// Makes a GET request to the specified [url],
  /// applying [mapperFunction] to the response.
  ///
  /// [queryParameters] - Optional query parameters.
  /// Returns the mapped response data.
  /// {@endtemplate}
  Future<T> getApi<T>(
    String url,
    T Function(dynamic data) mapperFunction, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final caller = dio.get<dynamic>(
      url,
      queryParameters: queryParameters,
    );
    return callApi(caller, mapperFunction);
  }

  /// {@template post_api}
  /// Makes a POST request to the specified [url],
  /// applying [mapperFunction] to the response.
  ///
  /// [queryParameters] - Optional query parameters.
  /// [sendBody] - Data (Map, List, etc.) to send in the body of the request.
  /// Returns the mapped response data.
  /// {@endtemplate}
  Future<T> postApi<T>(
    String url,
    T Function(dynamic value) mapperFunction, {
    Map<String, dynamic>? queryParameters,
    Object? sendBody,
  }) async {
    final caller = dio.post<dynamic>(
      url,
      queryParameters: queryParameters,
      data: jsonEncode(sendBody),
    );
    return callApi(caller, mapperFunction);
  }

  /// {@template patch_api}
  /// Makes a PATCH request to the specified [url],
  /// applying [mapperFunction] to the response.
  ///
  /// [queryParameters] - Optional query parameters.
  /// [sendBody] - Data (Map, List, etc.) to send in the body of the request.
  /// Returns the mapped response data.
  /// {@endtemplate}
  Future<T> patchApi<T>(
    String url,
    T Function(dynamic value) mapperFunction, {
    Map<String, dynamic>? queryParameters,
    Object? sendBody,
  }) async {
    final caller = dio.patch<dynamic>(
      url,
      queryParameters: queryParameters,
      data: jsonEncode(sendBody),
    );
    return callApi(caller, mapperFunction);
  }

  /// {@template delete_api}
  /// Makes a DELETE request to the specified [url],
  /// applying [mapperFunction] to the response.
  ///
  /// [queryParameters] - Optional query parameters.
  /// Returns the mapped response data.
  /// {@endtemplate}
  Future<T> deleteApi<T>(
    String url,
    T Function(dynamic data) mapperFunction, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final caller = dio.delete<dynamic>(
      url,
      queryParameters: queryParameters,
    );
    return callApi(caller, mapperFunction);
  }
}
