import 'package:flutter/foundation.dart';

@immutable
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.image,
  });

  final int id;
  final String name;
  final String description;
  final int quantity;
  final double price;
  final String image;
}
