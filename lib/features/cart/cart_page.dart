import 'package:commandy/commandy.dart';
import 'package:flutter/material.dart';
import 'package:salonguru/config/routes.dart';
import 'package:salonguru/di/shared_dependencies.dart';
import 'package:salonguru/domain/entities/cart_item.dart';
import 'package:salonguru/features/cart/cart_view_model.dart';
import 'package:salonguru/features/products/detail/widgets/counter.dart';
import 'package:salonguru/features/products/widgets/widgets.dart';
import 'package:salonguru/l10n/l10n.dart';
import 'package:salonguru/ui/widgets/alert.dart';
import 'package:salonguru/ui/widgets/currency_text.dart';
import 'package:salonguru/ui/widgets/empty_data.dart';
import 'package:salonguru/ui/widgets/loading.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final viewModel = sl<CartViewModel>()..loadCartItemsCommand.execute(const NoParams());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return CommandListener(
      listeners: [
        CommandListenerConfig(
          command: viewModel.doCheckoutCommand,
          listener: (context, result) {
            result?.fold(
              (data) {
                SuccessRoute().go(context);
              },
              (failure) {
                Alert.show(
                  context,
                  model: AlertModel(
                    text: l10n.alertCheckoutError,
                    title: l10n.alertCheckoutErrorTitle,
                  ),
                );
              },
            );
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.yellow[50],
        floatingActionButton: FloatingActionButton.small(
          backgroundColor: const Color(0xffec837d),
          foregroundColor: Colors.white,
          onPressed: () {
            viewModel.clearCartCommand.execute(const NoParams());
          },
          child: const Icon(Icons.delete_outline_outlined),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.yellow[50],
              flexibleSpace: FlexibleSpaceBar(
                background: const Hero(
                  tag: 'cart-hero',
                  child: ColoredBox(color: Colors.blueGrey),
                ),
                title: Text(
                  l10n.myCart,
                  style: textTheme.headlineSmall?.copyWith(
                    color: Colors.yellow[50],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 8),
            ),
            ValueListenableBuilder(
              valueListenable: viewModel.loadCartItemsCommand.result,
              builder: (context, result, child) {
                final cartItems = result?.fold(
                  (data) => data,
                  (failure) => <CartItem>[],
                );

                return switch (cartItems) {
                  null => const SliverFillRemaining(
                      child: Center(
                        child: Loading(),
                      ),
                    ),
                  [...] => cartItems.isEmpty
                      ? SliverFillRemaining(
                          child: EmptyData(item: l10n.productsItemG),
                        )
                      : SliverList.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = cartItems[index];
                            final product = cartItem.product;

                            return Card(
                              margin: const EdgeInsets.all(16),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            spacing: 10,
                                            children: [
                                              Badge.count(
                                                count: cartItem.quantity,
                                                alignment: Alignment.topLeft,
                                                child: BlurImage(
                                                  path: product.image,
                                                  sizePercent: .1,
                                                ),
                                              ),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  spacing: 10,
                                                  children: [
                                                    Text(
                                                      product.name,
                                                      overflow: TextOverflow.fade,
                                                      maxLines: 2,
                                                      textAlign: TextAlign.center,
                                                      style: textTheme.labelLarge,
                                                    ),
                                                    Text(
                                                      product.description,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                    CurrencyText(
                                                      cost: product.price,
                                                      smallextStyle: textTheme.bodySmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      textStyle: textTheme.bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Counter(
                                          quantity: cartItem.quantity,
                                          onTapped: (value) {
                                            if (cartItem.quantity < 1) {
                                              return;
                                            }
                                            if (value) {
                                              if (cartItem.quantity < product.quantity) {
                                                final newItem = CartItem(
                                                  product: product,
                                                  quantity: 1,
                                                );
                                                viewModel.updateCartCommand.execute(newItem);
                                              }
                                            } else {
                                              if (cartItem.quantity > 1) {
                                                final newItem = CartItem(
                                                  product: product,
                                                  quantity: -1,
                                                );
                                                viewModel.updateCartCommand.execute(newItem);
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: -20,
                                    right: 10,
                                    child: IconButton(
                                      color: Colors.red,
                                      onPressed: () {},
                                      icon: const Icon(Icons.remove_circle_rounded),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                };
              },
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              ViewModelSelector(
                viewModel: viewModel,
                selector: (vm) => vm.totalCost,
                builder: (context, total) => (total ?? 0) == 0
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 10,
                        children: [
                          Column(
                            children: [
                              Text(l10n.items),
                              Text(
                                '${viewModel.items}',
                                style: textTheme.headlineMedium,
                              ),
                            ],
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.black,
                          ),
                          Column(
                            children: [
                              Text(l10n.totalCost),
                              CurrencyText(
                                cost: total!,
                                smallextStyle: textTheme.headlineMedium,
                                textStyle: textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
              AnimatedBuilder(
                animation: viewModel,
                builder: (context, child) {
                  final deactiveted = viewModel.loading || ((viewModel.totalCost ?? 0) <= 0);

                  return FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xffec837d),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: deactiveted ? null : () => viewModel.doCheckoutCommand.execute(const NoParams()),
                    child: Text(
                      l10n.proceedCheckout,
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
