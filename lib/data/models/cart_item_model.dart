import 'package:salonguru/data/models/product_model.dart';
import 'package:salonguru/domain/entities/cart_item.dart';

class CartItemModel {
  const CartItemModel({
    required this.productModel,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'productModel': final Map<String, dynamic> productJson,
          'quantity': final int quantity,
        } =>
          CartItemModel(
            productModel: ProductModel.fromJson(productJson),
            quantity: quantity,
          ),
        _ => throw FormatException('Invalid CartItemModel JSON: $json'),
      };

  final ProductModel productModel;
  final int quantity;

  Map<String, dynamic> toJson() => {
        'productModel': productModel.toJson(),
        'quantity': quantity,
      };
}

/// CartItemModel → CartItem (Domain)
extension CartItemModelMapper on CartItemModel {
  CartItem toDomain() {
    return CartItem(
      product: productModel.toDomain(),
      quantity: quantity,
    );
  }
}

/// CartItem (Domain) → CartItemModel (Data)
extension CartItemMapper on CartItem {
  CartItemModel toData() {
    return CartItemModel(
      productModel: product.toData(),
      quantity: quantity,
    );
  }
}
