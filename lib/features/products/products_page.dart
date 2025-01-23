import 'package:commandy/commandy.dart';
import 'package:flutter/material.dart';
import 'package:salonguru/di/shared_dependencies.dart';
import 'package:salonguru/domain/entities/product.dart';
import 'package:salonguru/features/products/products_mobile_portrait.dart';
import 'package:salonguru/features/products/products_view_model.dart';
import 'package:salonguru/l10n/l10n.dart';
import 'package:salonguru/ui/pages/error_page.dart';
import 'package:salonguru/ui/widgets/adaptative_layout.dart';
import 'package:salonguru/ui/widgets/alert.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final productsViewModel = sl<ProductsViewModel>();

  @override
  void initState() {
    super.initState();
    productsViewModel.loadProductsCommand.execute(const NoParams());
    productsViewModel.loadCartItemsCommand.execute(const NoParams());
  }

  void processResult(Result<void>? result) {
    final l10n = context.l10n;

    final model = result?.fold(
      (_) => AlertModel(
        text: l10n.succesAlertText,
        title: l10n.succesAlertTitle,
      ),
      (failure) => AlertModel(
        text: failure.message,
        title: l10n.errorAlertText,
        type: AlertType.error,
      ),
    );
    if (result != null) {
      Alert.show(
        context,
        model: model!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommandListener(
      listeners: [
        CommandListenerConfig(
          command: productsViewModel.addToCartCommand,
          listener: (context, result) {
            processResult(result);
          },
        ),
      ],
      child: ValueListenableBuilder(
        valueListenable: productsViewModel.loadProductsCommand.result,
        builder: (context, result, child) {
          final component = result?.fold<Widget>(
            (products) => ValueListenableBuilder(
              valueListenable: productsViewModel.loadCartItemsCommand.result,
              builder: (context, value, child) {
                final cartItems = value?.fold(
                  (ci) => ci,
                  (failure) => null,
                );
                return ProductsMobilePortrait(
                  products: products,
                  cartItems: cartItems,
                  onRefresh: () => productsViewModel.loadProductsCommand.execute(const NoParams()),
                  onAddToCartPressed: (Product product) {
                    productsViewModel.addToCartCommand.execute(product);
                  },
                );
              },
            ),
            (failure) => ErrorPage(
              errorMessage: failure.message,
              onRetry: () => productsViewModel.loadProductsCommand.execute(const NoParams()),
            ),
          );
          return AdaptiveLayout(
            mobilePortrait: component ??
                ProductsMobilePortrait(
                  onRefresh: () => productsViewModel.loadProductsCommand.execute(const NoParams()),
                  onAddToCartPressed: (Product value) {},
                ),
          );
        },
      ),
    );
  }
}
