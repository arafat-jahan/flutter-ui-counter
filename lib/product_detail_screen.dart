import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../product_model.dart';
import '../cart_controller.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  ProductDetailScreen({required this.product});

  // Create instance of CartController
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.image, height: 200),
            SizedBox(height: 10),
            Text(product.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('\$${product.price}', style: TextStyle(fontSize: 24, color: Colors.green)),
            SizedBox(height: 10),
            Text(product.description, style: TextStyle(fontSize: 16)),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Add to Cart logic here
                cartController.addToCart(product);  // Add product to cart
                Get.snackbar('Success', '${product.title} added to cart');
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
