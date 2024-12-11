import 'package:flutter/material.dart';
import 'package:fpr/product_detail_screen.dart';
import 'package:get/get.dart';
import '../product_controller.dart';

class ProductListScreen extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-commerce App'),
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: productController.productList.length,
            itemBuilder: (context, index) {
              var product = productController.productList[index];
              return ListTile(
                leading: Image.network(product.image, width: 50, height: 50),
                title: Text(product.title),
                subtitle: Text('\$${product.price}'),
                onTap: () {
                  Get.to(() => ProductDetailScreen(product: product));
                },
              );
            },
          );
        }
      }),
    );
  }
}
