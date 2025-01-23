import 'package:commandy/commandy.dart';
import 'package:salonguru/domain/entities/cart_item.dart';

abstract interface class CartRepository {
  Future<Result<void>> addToCart(CartItem item);
  Future<Result<List<CartItem>>> getCartItems();
  Future<Result<void>> clearCart();
}
