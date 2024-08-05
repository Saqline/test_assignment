import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductRepository {
  
  final String baseUrl = 'https://demo.limerickbd.com/backend/public/api';

  Future<List<Product>> fetchProducts(String token) async {
    print("Come 1");
    final response = await http.get(
      Uri.parse('$baseUrl/fg-with-stock'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> productList = json.decode(response.body);
      return productList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products: ${response.statusCode} ${response.body}');
    }
  }
}
