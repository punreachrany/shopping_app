import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/shares/constants.dart';

class ProductAPI {
  // Get all products
  Future<List<dynamic>> getAllProducts() async {
    final url = Uri.parse('$BASE_URL/products/all/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Create a new product
  Future<Map<String, dynamic>> createProduct(
      Map<String, dynamic> productData) async {
    final url = Uri.parse('$BASE_URL/products/create/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create product');
    }
  }

  // Get product details by ID
  Future<Map<String, dynamic>> getProductDetail(int id) async {
    final url = Uri.parse('$BASE_URL/products/$id/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  // Update a product
  Future<Map<String, dynamic>> updateProduct(
      int id, Map<String, dynamic> productData) async {
    final url = Uri.parse('$BASE_URL/products/$id/');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update product');
    }
  }

  // Delete a product
  Future<void> deleteProduct(int id) async {
    final url = Uri.parse('$BASE_URL/products/$id/');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete product');
    }
  }

  // Get paginated products
  Future<List<dynamic>> getPaginatedProducts(int page, int number) async {
    final url =
        Uri.parse('$BASE_URL/products/paginated/?number=$number&page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load paginated products');
    }
  }

  // Get products by category
  Future<List<dynamic>> getProductsByCategory(
      String category, int page, int number) async {
    final url = Uri.parse(
        '$BASE_URL/products/category/?category=$category&number=$number&page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products by category');
    }
  }
}
