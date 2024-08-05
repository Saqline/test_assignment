import 'dart:convert';
import 'package:e_commerce_app/models/product.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String baseUrl = 'https://demo.limerickbd.com/backend/public/api';

  Future<String?> authenticate(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final token = json.decode(response.body)['token'];
    
      return json.decode(response.body)['token'];
      
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to logout');
    }
  }
}
