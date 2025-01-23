import 'dart:async';

import 'package:flutter/material.dart';
import 'package:salonguru/config/sg_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef AppBuilder = FutureOr<Widget> Function(
  SharedPreferences sharedPreferences,
);

Future<void> bootstrap(AppBuilder builder) async {
  FlutterError.onError = (details) {
    debugPrintStack(
      stackTrace: details.stack,
      label: details.exceptionAsString(),
    );
  };

  final sharedPreferences = await SharedPreferences.getInstance();
  SgNavigation.instance;

  runApp(await builder(sharedPreferences));
}
