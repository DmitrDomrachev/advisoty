import 'dart:async';
import 'dart:developer';

import 'package:alpha_advisory/service_locator/injectable.dart';
import 'package:flutter/widgets.dart';

import 'app/app.dart';

void bootstrap() async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };


  await setupGetIt();

  runZonedGuarded(() => runApp(const App()), (error, stack) {});
}
