import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salonguru/domain/entities/product.dart';
import 'package:salonguru/features/cart/cart_page.dart';
import 'package:salonguru/features/checkout/checkout_page.dart';
import 'package:salonguru/features/features.dart';
import 'package:salonguru/ui/pages/purchase_success_page.dart';

part 'routes.g.dart';

@TypedGoRoute<ProductsRoute>(
  path: '/products',
  routes: [
    TypedGoRoute<ProductDetailRoute>(
      path: 'detail',
    ),
    TypedGoRoute<CartRoute>(
      path: 'cart',
      routes: [
        TypedGoRoute<SuccessRoute>(
          path: 'success',
        ),
      ],
    ),
  ],
)
@immutable
class ProductsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProductsPage();
  }
}

@immutable
class ProductDetailRoute extends GoRouteData {
  const ProductDetailRoute({required this.$extra});

  final Product $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProductDetail(
      product: $extra,
    );
  }
}

@immutable
class CartRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CartPage();
  }
}

@TypedGoRoute<CheckoutRoute>(
  path: '/checkout',
  routes: [],
)
@immutable
class CheckoutRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CheckoutPage();
  }
}

@immutable
class SuccessRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PurchaseSuccessPage();
  }
}
