import 'dart:async';

import 'package:commandy/commandy.dart';
import 'package:flutter/material.dart';
import 'package:salonguru/domain/entities/cart_item.dart';
import 'package:salonguru/domain/entities/checkout_response.dart';
import 'package:salonguru/domain/usecases/add_to_cart_use_case.dart';
import 'package:salonguru/domain/usecases/checkout_use_case.dart';
import 'package:salonguru/domain/usecases/clear_cart_use_case.dart';
import 'package:salonguru/domain/usecases/get_cart_items_use_case.dart';

class CartViewModel extends ChangeNotifier {
  CartViewModel({
    required GetCartItemsUseCase cartItemsUseCase,
    required CheckoutUseCase checkoutUseCase,
    required ClearCartUseCase clearUseCase,
    required AddToCartUseCase addToCartUseCase,
  })  : _cartItemsUseCase = cartItemsUseCase,
        _checkoutUseCase = checkoutUseCase,
        _clearUseCase = clearUseCase,
        _addToCartUseCase = addToCartUseCase {
    loadCartItemsCommand = Command<List<CartItem>, NoParams>(_loadCartItems);
    doCheckoutCommand = Command<CheckoutResponse, NoParams>(_doCheckout);
    clearCartCommand = Command<void, NoParams>(_clearCart);
    updateCartCommand = Command<void, CartItem>(_updateCart);
  }

  late final Command<List<CartItem>, NoParams> loadCartItemsCommand;
  late final Command<CheckoutResponse, NoParams> doCheckoutCommand;
  late final Command<void, NoParams> clearCartCommand;
  late final Command<void, CartItem> updateCartCommand;
  final GetCartItemsUseCase _cartItemsUseCase;
  final CheckoutUseCase _checkoutUseCase;
  final ClearCartUseCase _clearUseCase;
  final AddToCartUseCase _addToCartUseCase;

  bool _loading = false;
  bool get loading => _loading;
  int? _items;
  int? get items => _items;
  double? _totalCost;
  double? get totalCost => _totalCost;
  CheckoutResponse? _checkoutResponse;
  CheckoutResponse? get checkoutResponse => _checkoutResponse;

  Future<Result<void>> _updateCart(CartItem item) async {
    final result = await _addToCartUseCase.call(item);
    unawaited(loadCartItemsCommand.execute(const NoParams()));
    return result;
  }

  Future<Result<void>> _clearCart(NoParams np) async {
    _loading = true;
    notifyListeners();
    final result = await _clearUseCase.call(np);
    unawaited(loadCartItemsCommand.execute(np));
    _loading = false;
    notifyListeners();
    return result;
  }

  Future<Result<List<CartItem>>> _loadCartItems(NoParams np) async {
    _loading = true;
    notifyListeners();
    final result = await _cartItemsUseCase.call(np);
    result.fold(
      (data) {
        if (data.isEmpty) {
          _items = null;
          _totalCost = null;
          return;
        }
        _items = data
            .map(
              (e) => e.quantity,
            )
            .reduce(
              (old, current) => old + current,
            );
        _totalCost = data
            .map(
              (e) => e.product.price * e.quantity,
            )
            .reduce(
              (old, current) => old + current,
            );
      },
      (failure) {
        _items = null;
        _totalCost = null;
      },
    );
    _loading = false;
    notifyListeners();
    return result;
  }

  Future<Result<CheckoutResponse>> _doCheckout(NoParams np) async {
    _loading = true;
    notifyListeners();
    final result = await _checkoutUseCase.call(np);
    result.fold(
      (data) {
        _checkoutResponse = data;
        clearCartCommand.execute(np);
      },
      (failure) {
        _checkoutResponse = null;
      },
    );
    _loading = false;
    notifyListeners();
    return result;
  }
}
