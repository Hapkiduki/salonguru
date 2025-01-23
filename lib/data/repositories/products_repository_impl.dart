import 'package:commandy/commandy.dart';
import 'package:network/network.dart';
import 'package:salonguru/data/models/checkout_item_model.dart';
import 'package:salonguru/data/models/checkout_response_model.dart';
import 'package:salonguru/data/models/product_model.dart';
import 'package:salonguru/data/sources/products_api_base.dart';
import 'package:salonguru/domain/entities/checkout_item.dart';
import 'package:salonguru/domain/entities/checkout_response.dart';
import 'package:salonguru/domain/entities/product.dart';
import 'package:salonguru/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  const ProductsRepositoryImpl({required ProductsApiBase productsApi}) : _productsApi = productsApi;

  final ProductsApiBase _productsApi;

  @override
  Future<Result<List<Product>>> getProducts() async {
    try {
      final productModels = await _productsApi.getProducts();
      final products = productModels
          .map(
            (model) => model.toDomain(),
          )
          .toList();
      return Success(products);
    } on NetworkException catch (e, s) {
      return FailureResult(
        Failure(
          message: e.message,
          exception: e,
          stackTrace: s,
        ),
      );
    } on Exception catch (e, s) {
      return FailureResult<List<Product>>(
        Failure(
          message: 'Unexpected error getting products',
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }

  @override
  Future<Result<CheckoutResponse>> checkout(List<CheckoutItem> items) async {
    try {
      final mappedItems = items
          .map(
            (e) => CheckoutItemModel.fromDomain(e).toJson(),
          )
          .toList();
      final checkoutResponseModel = await _productsApi.checkout(mappedItems);

      return Success(checkoutResponseModel.toDomain());
    } on NetworkException catch (e, s) {
      return FailureResult<CheckoutResponse>(
        Failure(
          message: e.message,
          exception: e,
          stackTrace: s,
        ),
      );
    } on Exception catch (e, s) {
      return FailureResult<CheckoutResponse>(
        Failure(
          message: 'Unexpected error during checkout',
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }
}
