import 'package:flutter/material.dart';
import 'package:shopping_app/screens/authentication/login.dart';
import 'package:shopping_app/screens/orders/orders.dart';
import 'package:shopping_app/screens/product_grid/product_details.dart';
import 'package:shopping_app/screens/product_grid/product_gird.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'NanumSquareRound',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OrdersPage(),
    );
  }
}
