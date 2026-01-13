import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  late Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Handle unauthorized
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Auth Endpoints
  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    try {
      final response = await _dio.post(
        '/auth/google',
        data: {'idToken': idToken},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      rethrow;
    }
  }

  // Product Endpoints
  Future<List<Product>> getProducts({String? category}) async {
    try {
      final params = category != null ? {'category': category} : null;
      final response = await _dio.get('/products', queryParameters: params);
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((p) => Product.fromJson(p as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> getProduct(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> createProduct(Product product) async {
    try {
      final response = await _dio.post(
        '/products',
        data: product.toJson(),
      );
      return Product.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> updateProduct(int id, Product product) async {
    try {
      final response = await _dio.put(
        '/products/$id',
        data: product.toJson(),
      );
      return Product.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _dio.delete('/products/$id');
    } catch (e) {
      rethrow;
    }
  }

  // Order Endpoints
  Future<Order> createOrder(Order order) async {
    try {
      final response = await _dio.post(
        '/orders',
        data: order.toJson(),
      );
      return Order.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Order>> getUserOrders() async {
    try {
      final response = await _dio.get('/orders');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((o) => Order.fromJson(o as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> getOrder(int id) async {
    try {
      final response = await _dio.get('/orders/$id');
      return Order.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Chat Endpoints
  Future<List<ChatMessage>> getChatMessages() async {
    try {
      final response = await _dio.get('/chat/messages');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((m) => ChatMessage.fromJson(m as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<ChatMessage> sendChatMessage(String message) async {
    try {
      final response = await _dio.post(
        '/chat/messages',
        data: {'message': message},
      );
      return ChatMessage.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Favorites Endpoints
  Future<List<Favorite>> getFavorites() async {
    try {
      final response = await _dio.get('/favorites');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((f) => Favorite.fromJson(f as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addFavorite(int productId) async {
    try {
      await _dio.post('/favorites', data: {'productId': productId});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFavorite(int productId) async {
    try {
      await _dio.delete('/favorites/$productId');
    } catch (e) {
      rethrow;
    }
  }
}
