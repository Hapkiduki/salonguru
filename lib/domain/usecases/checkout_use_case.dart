import 'package:commandy/commandy.dart';
import 'package:salonguru/domain/entities/checkout_item.dart';
import 'package:salonguru/domain/entities/checkout_response.dart';
import 'package:salonguru/domain/repositories/cart_repository.dart';
import 'package:salonguru/domain/repositories/products_repository.dart';
import 'package:salonguru/domain/usecases/base_use_case.dart';

/// use case to do checkout:
/// 1. Get the items from the cart
/// 2. call checkout within ProductRepository (API or Mock)
/// 3. Clear the cart and return [CheckoutResponse]
class CheckoutUseCase implements BaseUseCase<CheckoutResponse, NoParams> {
  const CheckoutUseCase({
    required CartRepository cartRepository,
    required ProductsRepository productRepository,
  })  : _cartRepository = cartRepository,
        _productRepository = productRepository;

  final CartRepository _cartRepository;
  final ProductsRepository _productRepository;

  @override
  Future<Result<CheckoutResponse>> call(NoParams _) async {
    final cartItemsResult = await _cartRepository.getCartItems();

    return cartItemsResult.fold(
      (cartItems) async {
        final checkoutItems = cartItems
            .map(
              (cartItem) => CheckoutItem(
                id: cartItem.product.id,
                quantity: cartItem.quantity,
              ),
            )
            .toList();

        final checkoutResult = await _productRepository.checkout(checkoutItems);

        return checkoutResult.fold(
          (checkoutResponse) async {
            final clearCartRes = await _cartRepository.clearCart();
            return clearCartRes.fold(
              (_) => Success(checkoutResponse),
              FailureResult<CheckoutResponse>.new,
            );
          },
          FailureResult<CheckoutResponse>.new,
        );
      },
      FailureResult<CheckoutResponse>.new,
    );
  }
}
