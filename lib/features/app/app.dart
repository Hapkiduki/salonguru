import 'package:flutter/material.dart';
import 'package:salonguru/config/sg_navigation.dart';
import 'package:salonguru/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: SgNavigation.instance.router,
      debugShowCheckedModeBanner: false,
      title: 'Salonguru',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
    );
  }
}
