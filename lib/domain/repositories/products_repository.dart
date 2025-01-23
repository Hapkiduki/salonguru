import 'package:commandy/commandy.dart';
import 'package:salonguru/domain/entities/checkout_item.dart';
import 'package:salonguru/domain/entities/checkout_response.dart';
import 'package:salonguru/domain/entities/product.dart';

abstract interface class ProductsRepository {
  Future<Result<List<Product>>> getProducts();
  Future<Result<CheckoutResponse>> checkout(List<CheckoutItem> items);
}
