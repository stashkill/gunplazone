import 'package:flutter/foundation.dart';
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
      print('✅ API Response: $response');

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
          }),
        );
        print('✅ Loaded ${_products.length} products from API');

        // Filter by category if specified
        if (category != null && category != 'All') {
          _filteredProducts = _products
              .where((p) => p['category'] == category)
              .toList();
        } else {
          _filteredProducts = [];
        }
      } else {
        print('❌ Empty response, loading mock products');
        _loadMockProducts();
      }
    } catch (e) {
      _error = 'Failed to fetch products: $e';
      print('❌ Error fetching products: $e');
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
        _products.add({
          'id': response['id'] ?? 0,
          'name': response['name'] ?? 'Unknown',
          'description': response['description'] ?? '',
          'price': response['price'] ?? 0,
          'category': response['category'] ?? 'Uncategorized',
          'stock': response['stock'] ?? 0,
          'image_url': response['image_url'] ?? '',
        });
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = 'Failed to create product: $e';
      print('Error creating product: $e');
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
        final index = _products.indexWhere((p) => p['id'] == id);
        if (index != -1) {
          _products[index] = {
            'id': response['id'] ?? id,
            'name': response['name'] ?? 'Unknown',
            'description': response['description'] ?? '',
            'price': response['price'] ?? 0,
            'category': response['category'] ?? 'Uncategorized',
            'stock': response['stock'] ?? 0,
            'image_url': response['image_url'] ?? '',
          };
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = 'Failed to update product: $e';
      print('Error updating product: $e');
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
      print('Error deleting product: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Load mock products (fallback)
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
      },
      {
        'id': 2,
        'name': 'HGCE 1/144 Mighty Strike Freedom',
        'description': 'High Grade Cosmic Era',
        'price': 219800,
        'category': 'HGCE',
        'stock': 5,
        'image_url': 'https://via.placeholder.com/300',
      },
      {
        'id': 3,
        'name': 'PG 1/60 RX-78-2 Gundam',
        'description': 'Perfect Grade Original Gundam',
        'price': 899000,
        'category': 'PG',
        'stock': 2,
        'image_url': 'https://via.placeholder.com/300',
      },
      {
        'id': 4,
        'name': 'RG 1/144 Sazabi',
        'description': 'Real Grade Sazabi',
        'price': 159900,
        'category': 'RG',
        'stock': 8,
        'image_url': 'https://via.placeholder.com/300',
      },
      {
        'id': 5,
        'name': 'MG 1/100 Unicorn Gundam',
        'description': 'Master Grade Unicorn',
        'price': 349900,
        'category': 'MG',
        'stock': 3,
        'image_url': 'https://via.placeholder.com/300',
      },
      {
        'id': 6,
        'name': 'HG 1/144 Barbatos',
        'description': 'High Grade Barbatos',
        'price': 129900,
        'category': 'HG',
        'stock': 12,
        'image_url': 'https://via.placeholder.com/300',
      },
      {
        'id': 7,
        'name': 'RE/100 Jagd Doga',
        'description': 'Real Experience Jagd Doga',
        'price': 179900,
        'category': 'RE/100',
        'stock': 4,
        'image_url': 'https://via.placeholder.com/300',
      },
      {
        'id': 8,
        'name': 'HG 1/144 Exia',
        'description': 'High Grade Exia',
        'price': 119900,
        'category': 'HG',
        'stock': 9,
        'image_url': 'https://via.placeholder.com/300',
      },
    ];
  }

  // Get products by category
  List<Map<String, dynamic>> getProductsByCategory(String category) {
    return _products.where((p) => p['category'] == category).toList();
  }

  // Clear filtered products
  void clearFilter() {
    _filteredProducts = [];
    _selectedCategory = null;
    notifyListeners();
  }
}
