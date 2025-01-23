import 'package:salonguru/domain/entities/checkout_response.dart';

class CheckoutItemDetailModel {
  const CheckoutItemDetailModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.description,
    required this.image,
  });

  factory CheckoutItemDetailModel.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'id': final int id,
          'name': final String name,
          'quantity': final int quantity,
          'price': final num price,
          'total_price': final num totalPrice,
          'description': final String description,
          'image': final String image,
        } =>
          CheckoutItemDetailModel(
            id: id,
            name: name,
            quantity: quantity,
            price: price.toDouble(),
            totalPrice: totalPrice.toDouble(),
            description: description,
            image: image,
          ),
        _ => throw FormatException('Invalid CheckoutItemDetail JSON: $json'),
      };

  final int id;
  final String name;
  final int quantity;
  final double price;
  final double totalPrice;
  final String description;
  final String image;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'quantity': quantity,
        'price': price,
        'total_price': totalPrice,
        'description': description,
        'image': image,
      };
}

class CheckoutResponseModel {
  const CheckoutResponseModel({
    required this.totalPrice,
    required this.items,
  });

  factory CheckoutResponseModel.fromJson(Map<String, dynamic> json) {
    final checkoutData = json['checkout'] as Map<String, dynamic>? ??
        (
          throw const FormatException(
            'Missing checkout key in response',
          ),
        );

    return switch (checkoutData) {
      {
        'total_price': final num totalPrice,
        'items': final List<dynamic> itemsList,
      } =>
        CheckoutResponseModel(
          totalPrice: totalPrice.toDouble(),
          items: itemsList.map((item) {
            return CheckoutItemDetailModel.fromJson(
              item as Map<String, dynamic>,
            );
          }).toList(),
        ),
      _ => throw FormatException('Invalid checkout structure: $json')
    };
  }

  final double totalPrice;
  final List<CheckoutItemDetailModel> items;

  Map<String, dynamic> toJson() => {
        'checkout': {
          'total_price': totalPrice,
          'items': items.map((e) => e.toJson()).toList(),
        },
      };
}

extension CheckoutResponseModelMapper on CheckoutResponseModel {
  CheckoutResponse toDomain() => CheckoutResponse(
        totalPrice: totalPrice,
        items: items.map((e) => e.toDomain()).toList(),
      );
}

extension CheckoutItemDetailModelMapper on CheckoutItemDetailModel {
  CheckoutItemDetail toDomain() => CheckoutItemDetail(
        id: id,
        name: name,
        quantity: quantity,
        price: price,
        totalPrice: totalPrice,
        description: description,
        image: image,
      );
}
