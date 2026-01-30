import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;
  String? _selectedCategory;

  // Getters
  List<Map<String, dynamic>> get products => _filteredProducts.isEmpty ? _products : _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedCategory => _selectedCategory;

  List<String> get categories => ['All', 'HG', 'RG', 'MG', 'PG', 'RE/100', 'HGCE'];

  // Fetch all products
  Future<void> fetchProducts({String? category}) async {
    _isLoading = true;
    _error = null;
    _selectedCategory = category;
    notifyListeners();

    try {
      final response = await _apiService.getProducts();

      if (response.isNotEmpty) {
        _products = List<Map<String, dynamic>>.from(
          response.map((p) => {
            'id': p['id'] ?? 0,
            'name': p['name'] ?? 'Unknown',
            'description': p['description'] ?? '',
            'price': p['price'] ?? 0,
            'category': p['category'] ?? 'Uncategorized',
            'stock': p['stock'] ?? 0,
            'image_url': p['image_url'] ?? '',
            'rating': p['rating'] ?? 0.0,
          }),
        );

        if (category != null && category != 'All') {
          _filteredProducts = _products
              .where((p) => p['category'] == category)
              .toList();
        } else {
          _filteredProducts = [];
        }
      } else {
        _loadMockProducts();
      }
    } catch (e) {
      _error = 'Failed to fetch products: $e';
      _loadMockProducts();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Search products
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      _filteredProducts = [];
      notifyListeners();
      return;
    }

    _filteredProducts = _products
        .where((p) =>
    (p['name'] as String).toLowerCase().contains(query.toLowerCase()) ||
        (p['description'] as String).toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  // Create product
  Future<bool> createProduct(Map<String, dynamic> product) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.createProduct(product);
      if (response != null) {
        await fetchProducts(); // Refresh list
        return true;
      }
    } on DioException catch (e) {
      _error = _parseDioError(e);
    } catch (e) {
      _error = 'Unexpected error: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Update product
  Future<bool> updateProduct(int id, Map<String, dynamic> product) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.updateProduct(id, product);
      if (response != null) {
        await fetchProducts(); // Refresh list
        return true;
      }
    } on DioException catch (e) {
      _error = _parseDioError(e);
    } catch (e) {
      _error = 'Unexpected error: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Delete product
  Future<bool> deleteProduct(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _apiService.deleteProduct(id);
      if (success) {
        _products.removeWhere((p) => p['id'] == id);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = 'Failed to delete product: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  String _parseDioError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return 'Server Error: ${data['message']}';
      }
      if (data is Map && data['error'] != null) {
        return 'Server Error: ${data['error']}';
      }
      return 'Server Error (${e.response?.statusCode}): ${e.response?.statusMessage}';
    }
    return 'Network Error: ${e.message}';
  }

  void _loadMockProducts() {
    _products = [
      {
        'id': 1,
        'name': 'HG 1/144 Kamgfer',
        'description': 'High Grade Kamgfer',
        'price': 109900,
        'category': 'HG',
        'stock': 10,
        'image_url': 'https://via.placeholder.com/300',
        'rating': 4.5,
      },
    ];
  }

  void clearFilter() {
    _filteredProducts = [];
    _selectedCategory = null;
    notifyListeners();
  }

  // Update token untuk API calls
  void updateToken(String? token) {
    _apiService.updateToken(token);
  }
}
