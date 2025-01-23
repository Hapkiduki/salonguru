import 'package:flutter/foundation.dart';
import 'package:salonguru/domain/entities/product.dart';

@immutable
class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
  });

  final Product product;
  final int quantity;
}
