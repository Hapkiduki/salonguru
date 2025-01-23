import 'dart:convert';

import 'package:salonguru/data/models/cart_item_model.dart';
import 'package:salonguru/domain/entities/cart_item.dart';
import 'package:storage/storage.dart';

abstract class CartLocalDataSource {
  Future<void> addToCart(CartItem item);
  Future<List<CartItem>> getCartItems();
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  CartLocalDataSourceImpl({required Storage storage}) : _storage = storage;

  final Storage _storage;
  static const _cartKey = 'SHOPPING_CART';

  @override
  Future<void> addToCart(CartItem item) async {
    final currentItems = await getCartItems();
    final index = currentItems.indexWhere(
      (c) => c.product.id == item.product.id,
    );
    final updatedList = [...currentItems];
    if (index >= 0) {
      final existing = updatedList[index];
      final newItem = CartItem(
        product: existing.product,
        quantity: existing.quantity + item.quantity,
      );
      updatedList[index] = newItem;
    } else {
      updatedList.add(item);
    }

    final cartItemModels = updatedList.map((ci) => ci.toData()).toList();
    final jsonList = cartItemModels.map((m) => m.toJson()).toList();

    await _storage.write(key: _cartKey, value: jsonEncode(jsonList));
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    final data = await _storage.read(key: _cartKey);
    if (data == null) return [];
    final list = json.decode(data as String) as List<dynamic>;

    final cartItemModels = list.map((jsonItem) {
      return CartItemModel.fromJson(jsonItem as Map<String, dynamic>);
    }).toList();

    return cartItemModels.map((m) => m.toDomain()).toList();
  }

  @override
  Future<void> clearCart() async {
    await _storage.delete(key: _cartKey);
  }
}
