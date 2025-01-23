import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salonguru/config/assets.dart';
import 'package:salonguru/data/models/checkout_response_model.dart';
import 'package:salonguru/data/models/product_model.dart';
import 'package:salonguru/data/sources/products_api_base.dart';

class ProductsApiMock implements ProductsApiBase {
  const ProductsApiMock();

  @override
  Future<List<ProductModel>> getProducts() async {
    final jsonString = await rootBundle.loadString(Assets.products);
    final data = json.decode(jsonString);
    await Future<void>.delayed(Durations.extralong4);
    return switch (data) {
      {'products': final List<dynamic> list} => list
          .map(
            (json) => ProductModel.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList(),
      _ => <ProductModel>[],
    };
  }

  @override
  Future<CheckoutResponseModel> checkout(List<Map<String, dynamic>> items) async {
    final jsonString = await rootBundle.loadString(Assets.checkout);
    final data = json.decode(jsonString) as Map<String, dynamic>;
    return CheckoutResponseModel.fromJson(data);
  }
}
