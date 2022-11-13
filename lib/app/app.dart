import 'package:alpha_advisory/features/auth/screens/screens.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  AuthPage(),
    );
  }
}