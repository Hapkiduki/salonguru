import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salonguru/config/routes.dart';
import 'package:salonguru/config/sg_codec.dart';

class SgNavigation {
  factory SgNavigation() {
    return _instance;
  }

  SgNavigation._internal() {
    _goRouter = GoRouter(
      navigatorKey: parentNavigatorKey,
      routes: $appRoutes,
      initialLocation: ProductsRoute().location,
      debugLogDiagnostics: true,
      extraCodec: SgCodec(),
    );
  }
  static final SgNavigation _instance = SgNavigation._internal();

  static SgNavigation get instance => _instance;

  late final GoRouter _goRouter;
  GoRouter get router => _goRouter;

  static final GlobalKey<NavigatorState> parentNavigatorKey = GlobalKey<NavigatorState>();

  BuildContext get context => router.routerDelegate.navigatorKey.currentContext!;

  GoRouterDelegate get routerDelegate => router.routerDelegate;

  GoRouteInformationParser get routeInformationParser => router.routeInformationParser;
}
