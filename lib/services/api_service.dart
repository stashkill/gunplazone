import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  late final Dio _dio;
  String? _token;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Tambahkan interceptor untuk logging detail request/response
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('🌐 API LOG: $obj'),
    ));

    // Interceptor untuk menambahkan token ke header secara dinamis
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null && _token!.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        return handler.next(options);
      },
    ));
  }

  // Update token untuk autentikasi
  void updateToken(String? token) {
    _token = token;
    print('🔑 API Token updated: ${token != null ? "SET" : "CLEARED"}');
  }

  // Get all products
  Future<List<dynamic>> getProducts({int retryCount = 0}) async {
    try {
      final response = await _dio.get('/products');
      final data = response.data;

      // Log untuk debugging data yang diterima
      print('🌐 API GET Response: $data');

      if (data is Map) {
        if (data['data'] != null) return List<dynamic>.from(data['data']);
        if (data['products'] != null) return List<dynamic>.from(data['products']);
      }

      if (data is List) {
        return data;
      }

      return [];
    } catch (e) {
      if (retryCount < 2 && (e is DioException && (e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.connectionTimeout))) {
        print('🌐 API LOG: Timeout detected, retrying... (${retryCount + 1})');
        return getProducts(retryCount: retryCount + 1);
      }
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

  // Helper untuk membersihkan data secara paksa (Hard-Clean)
  Map<String, dynamic> _hardCleanData(Map<String, dynamic> data) {
    // Hanya izinkan field yang ada di database MySQL Anda
    final Map<String, dynamic> clean = {
      'name': data['name']?.toString() ?? '',
      'category': data['category']?.toString() ?? '',
      'price': int.tryParse(data['price']?.toString() ?? '0') ?? 0,
      'stock': int.tryParse(data['stock']?.toString() ?? '0') ?? 0,
      'description': data['description']?.toString() ?? '',
      'image_url': (data['image_url'] ?? data['imageUrl'])?.toString() ?? '',
      'rating': double.tryParse(data['rating']?.toString() ?? '0.0') ?? 0.0,
    };

    // LOGGING INTERNAL UNTUK MEMASTIKAN DATA BERSIH
    print('🛡️ HARD-CLEAN: Data prepared for server: $clean');
    return clean;
  }

  // Create product
  Future<dynamic> createProduct(Map<String, dynamic> product) async {
    try {
      final sanitizedData = _hardCleanData(product);
      final response = await _dio.post('/products', data: sanitizedData);
      return response.data;
    } on DioException catch (e) {
      print('❌ Dio Error (Create): ${e.response?.statusCode} - ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Error creating product: $e');
      return null;
    }
  }

  // Update product
  Future<dynamic> updateProduct(int id, Map<String, dynamic> product) async {
    try {
      final sanitizedData = _hardCleanData(product);
      final response = await _dio.put('/products/$id', data: sanitizedData);
      return response.data;
    } on DioException catch (e) {
      print('❌ Dio Error (Update): ${e.response?.statusCode} - ${e.response?.data}');
      rethrow;
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
