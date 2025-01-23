// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $productsRoute,
      $checkoutRoute,
    ];

RouteBase get $productsRoute => GoRouteData.$route(
      path: '/products',
      factory: $ProductsRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'detail',
          factory: $ProductDetailRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'cart',
          factory: $CartRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'success',
              factory: $SuccessRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $ProductsRouteExtension on ProductsRoute {
  static ProductsRoute _fromState(GoRouterState state) => ProductsRoute();

  String get location => GoRouteData.$location(
        '/products',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProductDetailRouteExtension on ProductDetailRoute {
  static ProductDetailRoute _fromState(GoRouterState state) =>
      ProductDetailRoute(
        $extra: state.extra as Product,
      );

  String get location => GoRouteData.$location(
        '/products/detail',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $CartRouteExtension on CartRoute {
  static CartRoute _fromState(GoRouterState state) => CartRoute();

  String get location => GoRouteData.$location(
        '/products/cart',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SuccessRouteExtension on SuccessRoute {
  static SuccessRoute _fromState(GoRouterState state) => SuccessRoute();

  String get location => GoRouteData.$location(
        '/products/cart/success',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $checkoutRoute => GoRouteData.$route(
      path: '/checkout',
      factory: $CheckoutRouteExtension._fromState,
    );

extension $CheckoutRouteExtension on CheckoutRoute {
  static CheckoutRoute _fromState(GoRouterState state) => CheckoutRoute();

  String get location => GoRouteData.$location(
        '/checkout',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
