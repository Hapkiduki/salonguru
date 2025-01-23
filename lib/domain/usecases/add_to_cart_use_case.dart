import 'package:commandy/commandy.dart';
import 'package:salonguru/domain/entities/cart_item.dart';
import 'package:salonguru/domain/repositories/cart_repository.dart';
import 'package:salonguru/domain/usecases/base_use_case.dart';

class AddToCartUseCase implements BaseUseCase<void, CartItem> {
  const AddToCartUseCase({
    required CartRepository cartRepository,
  }) : _cartRepository = cartRepository;

  final CartRepository _cartRepository;

  @override
  Future<Result<void>> call(CartItem item) => _cartRepository.addToCart(item);
}
