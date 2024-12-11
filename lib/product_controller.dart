import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../product_model.dart';

class ProductController extends GetxController {
  var productList = <Product>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body) as List;
        productList.value = jsonData.map((product) => Product.fromJson(product)).toList();
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }
}
