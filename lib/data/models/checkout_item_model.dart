import 'package:salonguru/domain/entities/checkout_item.dart';

class CheckoutItemModel {
  const CheckoutItemModel({
    required this.productId,
    required this.quantity,
  });

  factory CheckoutItemModel.fromDomain(CheckoutItem item) {
    return CheckoutItemModel(productId: item.id, quantity: item.quantity);
  }

  final int productId;
  final int quantity;

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'quantity': quantity,
      };
}
