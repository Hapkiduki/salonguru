import 'package:network/network.dart';

class RequestDataProviderImpl implements RequestData {
  static const String headerContentType = 'Content-Type';
  static const String contentType = 'application/json';
  static const String headerXApiKey = 'x-api-key';

  @override
  Future<Map<String, String>> get headers async => {
        headerContentType: contentType,
        headerXApiKey: await getXApiKey(),
      };

  Future<String> getXApiKey() async {
    return 'BxWr6VUVph4KszpHX1cCJ2MRXwERAqEj3ZhHRgiH';
  }
}
