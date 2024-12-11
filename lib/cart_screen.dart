import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cart_controller.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(child: Text('No items in cart'));
        } else {
          return ListView.builder(
            itemCount: cartController.cartItems.length,
            itemBuilder: (context, index) {
              var product = cartController.cartItems[index];
              return ListTile(
                title: Text(product.title),
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () => cartController.removeFromCart(product),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
