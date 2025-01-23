import 'package:commandy/commandy.dart';
import 'package:salonguru/domain/repositories/cart_repository.dart';
import 'package:salonguru/domain/usecases/base_use_case.dart';

class ClearCartUseCase implements BaseUseCase<void, NoParams> {
  const ClearCartUseCase({
    required CartRepository cartRepository,
  }) : _cartRepository = cartRepository;

  final CartRepository _cartRepository;

  @override
  Future<Result<void>> call(NoParams params) => _cartRepository.clearCart();
}
