import 'package:commandy/commandy.dart';
import 'package:salonguru/data/sources/cart_local_datasource.dart';
import 'package:salonguru/domain/entities/cart_item.dart';
import 'package:salonguru/domain/repositories/cart_repository.dart';
import 'package:storage/storage.dart';

class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl({
    required CartLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  final CartLocalDataSource _localDataSource;

  @override
  Future<Result<void>> addToCart(CartItem item) async {
    try {
      await _localDataSource.addToCart(item);
      return const Success(null);
    } on StorageException catch (e, s) {
      return FailureResult<void>(
        Failure(
          message: 'Error writing cart item',
          exception: e,
          stackTrace: s,
        ),
      );
    } on Exception catch (e, s) {
      return FailureResult<void>(
        Failure(
          message: 'Unexpected error adding cart item',
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }

  @override
  Future<Result<List<CartItem>>> getCartItems() async {
    try {
      final cartItems = await _localDataSource.getCartItems();
      return Success(cartItems);
    } on StorageException catch (e, s) {
      return FailureResult<List<CartItem>>(
        Failure(
          message: 'Error reading cart items',
          exception: e,
          stackTrace: s,
        ),
      );
    } on Exception catch (e, s) {
      return FailureResult<List<CartItem>>(
        Failure(
          message: 'Unexpected error reading cart items',
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }

  @override
  Future<Result<void>> clearCart() async {
    try {
      await _localDataSource.clearCart();
      return const Success(null);
    } on StorageException catch (e, s) {
      return FailureResult<void>(
        Failure(
          message: 'Error clearing cart',
          exception: e,
          stackTrace: s,
        ),
      );
    } on Exception catch (e, s) {
      return FailureResult<void>(
        Failure(
          message: 'Unexpected error clearing cart',
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }
}
