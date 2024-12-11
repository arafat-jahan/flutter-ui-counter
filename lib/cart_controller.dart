import 'package:get/get.dart';
import './product_model.dart';

class CartController extends GetxController {
  var cartItems = <Product>[].obs;

  void addToCart(Product product) {
    cartItems.add(product);
    update();  // To notify the UI about the change
  }

  void removeFromCart(Product product) {
    cartItems.remove(product);
    update();  // To notify the UI about the change
  }
}
