import 'package:salonguru/data/models/checkout_response_model.dart';
import 'package:salonguru/data/models/product_model.dart';

abstract interface class ProductsApiBase {
  Future<List<ProductModel>> getProducts();
  Future<CheckoutResponseModel> checkout(List<Map<String, dynamic>> items);
}
