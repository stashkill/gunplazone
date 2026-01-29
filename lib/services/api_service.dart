import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5 ),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  // Get all products
  Future<List<dynamic>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      final data = response.data;

      // Handle jika response adalah Map dengan 'data' field
      if (data is Map && data['data'] != null) {
        return List<dynamic>.from(data['data']);
      }

      // Handle jika response langsung List
      if (data is List) {
        return data;
      }

      return [];
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Get product by ID
  Future<dynamic> getProduct(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return response.data;
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  // Create product
  Future<dynamic> createProduct(Map<String, dynamic> product) async {
    try {
      final response = await _dio.post('/products', data: product);
      return response.data;
    } catch (e) {
      print('Error creating product: $e');
      return null;
    }
  }

  // Update product
  Future<dynamic> updateProduct(int id, Map<String, dynamic> product) async {
    try {
      final response = await _dio.put('/products/$id', data: product);
      return response.data;
    } catch (e) {
      print('Error updating product: $e');
      return null;
    }
  }

  // Delete product
  Future<bool> deleteProduct(int id) async {
    try {
      await _dio.delete('/products/$id');
      return true;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }

  // Get user
  Future<dynamic> getUser(String email) async {
    try {
      final response = await _dio.get('/users/$email');
      return response.data;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  // Create user
  Future<dynamic> createUser(String email, String name) async {
    try {
      final response = await _dio.post('/users', data: {
        'email': email,
        'name': name,
        'role': 'user',
      });
      return response.data;
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }

  // Create order
  Future<dynamic> createOrder(Map<String, dynamic> order) async {
    try {
      final response = await _dio.post('/orders', data: order);
      return response.data;
    } catch (e) {
      print('Error creating order: $e');
      return null;
    }
  }

  // Get user orders
  Future<List<dynamic>> getUserOrders(int userId) async {
    try {
      final response = await _dio.get('/orders/user/$userId');
      return response.data;
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  // Health check
  Future<bool> healthCheck() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      print('Backend not available: $e');
      return false;
    }
  }
}