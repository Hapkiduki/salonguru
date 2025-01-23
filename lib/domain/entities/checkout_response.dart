import 'package:flutter/foundation.dart';

@immutable
class CheckoutResponse {
  const CheckoutResponse({
    required this.totalPrice,
    required this.items,
  });

  final double totalPrice;
  final List<CheckoutItemDetail> items;
}

@immutable
class CheckoutItemDetail {
  const CheckoutItemDetail({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.description,
    required this.image,
  });

  final int id;
  final String name;
  final int quantity;
  final double price;
  final double totalPrice;
  final String description;
  final String image;
}
