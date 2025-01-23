import 'package:salonguru/domain/entities/product.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'id': final int id,
          'name': final String name,
          'description': final String description,
          'quantity': final int quantity,
          'price': final double price,
          'image': final String image,
        } =>
          ProductModel(
            id: id,
            name: name,
            description: description,
            quantity: quantity,
            price: price,
            image: image,
          ),
        _ => throw FormatException('Invalid ProductModel JSON: $json'),
      };

  final int id;
  final String name;
  final String description;
  final int quantity;
  final double price;
  final String image;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'quantity': quantity,
        'price': price,
        'image': image,
      };
}

extension ProductModelMapper on ProductModel {
  Product toDomain() {
    return Product(
      id: id,
      name: name,
      description: description,
      quantity: quantity,
      price: price,
      image: image,
    );
  }
}

extension ProductMapper on Product {
  ProductModel toData() {
    return ProductModel(
      id: id,
      name: name,
      description: description,
      quantity: quantity,
      price: price,
      image: image,
    );
  }
}
