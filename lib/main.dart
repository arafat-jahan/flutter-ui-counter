import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/product_list_screen.dart'; // Product List screen import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'E-commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductListScreen(), // Product list screen এ প্রথমে দেখাবে
    );
  }
}
