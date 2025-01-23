import 'package:flutter/material.dart';
import 'package:salonguru/config/routes.dart';
import 'package:salonguru/di/shared_dependencies.dart';
import 'package:salonguru/features/cart/cart_view_model.dart';
import 'package:salonguru/features/products/widgets/widgets.dart';
import 'package:salonguru/l10n/l10n.dart';
import 'package:salonguru/ui/widgets/currency_text.dart';
import 'package:salonguru/utils/currency_extension.dart';

class CheckoutPage extends StatelessWidget {
  CheckoutPage({super.key});

  final viewModel = sl<CartViewModel>();

  @override
  Widget build(BuildContext context) {
    final response = viewModel.checkoutResponse!;

    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.yellow[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                l10n.checkout,
                style: textTheme.headlineSmall?.copyWith(
                  color: Colors.yellow[50],
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffef907a),
                      Color(0xfff19c77),
                      Color(0xffed867d),
                      Color(0xffed857c),
                      Color(0xffec837d),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          SliverList.separated(
            itemCount: response.items.length,
            separatorBuilder: (context, index) => const Divider(
              endIndent: 30,
              indent: 30,
            ),
            itemBuilder: (context, index) {
              final item = response.items[index];

              return Padding(
                padding: const EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    BlurImage(
                      path: item.image,
                      sizePercent: .1,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Text(
                            item.name,
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: textTheme.labelLarge,
                          ),
                          Text(
                            item.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.quantity} X ${item.price.formatCurrency()}',
                                style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CurrencyText(
                                cost: item.totalPrice,
                                smallextStyle: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textStyle: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(border: BorderDirectional(top: BorderSide())),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 32,
        ),
        child: Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(l10n.itemsAmount),
                    Text(
                      response.items
                          .map(
                            (e) => e.quantity,
                          )
                          .reduce(
                            (value, element) => value + element,
                          )
                          .toString(),
                      style: textTheme.headlineMedium,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(l10n.totalCost),
                    CurrencyText(
                      cost: response.totalPrice,
                      smallextStyle: textTheme.headlineMedium,
                      textStyle: textTheme.headlineSmall,
                    ),
                  ],
                ),
              ],
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xffec837d),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => ProductsRoute().go(context),
              child: Text(
                l10n.backProductsButton,
                style: textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
