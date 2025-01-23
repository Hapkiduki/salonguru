import 'dart:async';

import 'package:commandy/commandy.dart';
import 'package:salonguru/domain/entities/cart_item.dart';
import 'package:salonguru/domain/entities/product.dart';
import 'package:salonguru/domain/usecases/add_to_cart_use_case.dart';
import 'package:salonguru/domain/usecases/get_cart_items_use_case.dart';
import 'package:salonguru/domain/usecases/get_products_use_case.dart';

class ProductsViewModel {
  ProductsViewModel({
    required GetProductsUseCase getProductsUseCase,
    required AddToCartUseCase addToCartUseCase,
    required GetCartItemsUseCase getCartItemsUseCase,
  })  : _getProductsUseCase = getProductsUseCase,
        _addToCartUseCase = addToCartUseCase,
        _cartItemsUseCase = getCartItemsUseCase {
    loadProductsCommand = Command<List<Product>, NoParams>(
      _loadProducts,
    );
    addToCartCommand = Command<void, Product>(
      _addToCart,
    );
    loadCartItemsCommand = Command<List<CartItem>, NoParams>(
      _loadCartItems,
    );
  }

  int contador = 0;

  Future<Result<void>> _addToCart(Product product) async {
    final result = await _addToCartUseCase(CartItem(product: product, quantity: 1));
    unawaited(loadCartItemsCommand.execute(const NoParams()));
    return result;
  }

  Future<Result<List<Product>>> _loadProducts(NoParams noParams) async {
    if (contador == 0) {
      contador += 1;
      await Future.delayed(Duration(seconds: 2));
      return FailureResult(Failure(message: 'Forbiden'));
    }
    final result = await _getProductsUseCase.call(noParams);
    return result;
  }

  Future<Result<List<CartItem>>> _loadCartItems(NoParams noParams) async {
    final result = await _cartItemsUseCase.call(noParams);
    return result;
  }

  final GetProductsUseCase _getProductsUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final GetCartItemsUseCase _cartItemsUseCase;
  late final Command<List<Product>, NoParams> loadProductsCommand;
  late final Command<List<CartItem>, NoParams> loadCartItemsCommand;
  late final Command<void, Product> addToCartCommand;
}
