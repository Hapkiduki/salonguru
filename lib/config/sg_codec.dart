import 'dart:convert';

import 'package:salonguru/data/models/product_model.dart';
import 'package:salonguru/domain/entities/product.dart';

class SgCodec extends Codec<Object?, Object?> {
  @override
  Converter<Object?, Object?> get decoder => SgDecoder();

  @override
  Converter<Object?, Object?> get encoder => SgEncoder();
}

class SgEncoder extends Converter<Object?, Object?> {
  @override
  Object? convert(Object? input) {
    if (input is Product) {
      return input.toData().toJson();
    }
    return null;
  }
}

class SgDecoder extends Converter<Object?, Object?> {
  @override
  Product? convert(Object? input) {
    if (input == null) {
      return null;
    }
    return ProductModel.fromJson(input as Map<String, dynamic>).toDomain();
  }
}
