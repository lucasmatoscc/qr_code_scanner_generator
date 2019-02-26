import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner_generator/telaLogin.dart';
import 'package:qr_code_scanner_generator/scan.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home',
      initialRoute: '/',
      routes: <String, WidgetBuilder> {
        '/': (context) => TelaLogin(),
        ScanScreen.routeName: (context) => ScanScreen(),
      },
    );
  }
}
