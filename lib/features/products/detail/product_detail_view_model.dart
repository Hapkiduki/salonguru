import 'package:commandy/commandy.dart';
import 'package:flutter/material.dart';
import 'package:salonguru/domain/entities/cart_item.dart';
import 'package:salonguru/domain/entities/product.dart';
import 'package:salonguru/domain/usecases/add_to_cart_use_case.dart';

class ProductDetailViewModel extends ChangeNotifier {
  ProductDetailViewModel({
    required AddToCartUseCase addToCardUseCase,
  }) : _addToCartUseCase = addToCardUseCase {
    addToCardCommand = Command<void, NoParams>(_addToCard);
    increaseCommand = Command<void, bool>(_increase);
    loadProductCommand = Command<void, Product>(
      _loadProduct,
    );
  }

  final AddToCartUseCase _addToCartUseCase;

  late final Product _product;
  Product get product => _product;

  int _quantity = 1;
  int get quantity => _quantity;

  late final Command<void, NoParams> addToCardCommand;
  late final Command<void, bool> increaseCommand;
  late final Command<void, Product> loadProductCommand;

  Future<Result<void>> _loadProduct(Product currentProduct) async {
    _product = currentProduct;
    return const Success(null);
  }

  Future<Result<void>> _increase(bool increase) async {
    if (increase && _quantity < _product.quantity) {
      _quantity += 1;
    } else {
      if (!increase && _quantity > 1) {
        _quantity -= 1;
      }
    }
    notifyListeners();
    return const Success(null);
  }

  Future<Result<void>> _addToCard(NoParams _) async {
    final item = CartItem(product: _product, quantity: _quantity);
    return _addToCartUseCase(item);
  }
}
