import 'package:network/network.dart';
import 'package:salonguru/data/models/checkout_response_model.dart';
import 'package:salonguru/data/models/product_model.dart';
import 'package:salonguru/data/sources/products_api_base.dart';

class ProductsApi with BaseApi implements ProductsApiBase {
  ProductsApi({required this.dioInstance});

  final Dio dioInstance;

  @override
  Dio get dio => dioInstance;

  @override
  Future<List<ProductModel>> getProducts() {
    return getApi<List<ProductModel>>(
      '/products',
      (data) => switch (data) {
        {'products': final List<dynamic> list} => list
            .map(
              (json) => ProductModel.fromJson(
                json as Map<String, dynamic>,
              ),
            )
            .toList(),
        _ => <ProductModel>[],
      },
    );
  }

  @override
  Future<CheckoutResponseModel> checkout(List<Map<String, dynamic>> items) async {
    final responseData = await postApi<CheckoutResponseModel>(
      '/checkout',
      (json) => CheckoutResponseModel.fromJson(json as Map<String, dynamic>),
      sendBody: items,
    );
    return responseData;
  }
}
