import 'package:flutter/material.dart';
import 'package:salonguru/di/mock_dependencies.dart';
import 'package:salonguru/di/remote_dependencies.dart';
import 'package:salonguru/features/app/app.dart';
import 'package:salonguru/features/app/bootstrap.dart';

import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();

  bootstrap(
    (sharedPreferences) {
      setupMockDependencies(sharedPreferences);
      //setupDependencies(sharedPreferences);
      return const App();
    },
  );
}
