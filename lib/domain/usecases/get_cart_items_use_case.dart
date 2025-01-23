import 'package:commandy/commandy.dart';
import 'package:salonguru/domain/entities/cart_item.dart';
import 'package:salonguru/domain/repositories/cart_repository.dart';
import 'package:salonguru/domain/usecases/base_use_case.dart';

class GetCartItemsUseCase implements BaseUseCase<List<CartItem>, NoParams> {
  const GetCartItemsUseCase({
    required CartRepository cartRepository,
  }) : _cartRepository = cartRepository;

  final CartRepository _cartRepository;

  @override
  Future<Result<List<CartItem>>> call(NoParams params) => _cartRepository.getCartItems();
}
