import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<Favorite> _favorites = [];
  bool _isLoading = false;
  String? _error;
  String? _selectedCategory;

  List<Product> get products => _filteredProducts.isEmpty ? _products : _filteredProducts;
  List<Favorite> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedCategory => _selectedCategory;

  List<String> get categories => [
    'All',
    'HG',
    'RG',
    'MG',
    'PG',
    'RE/100',
  ];

  Future<void> fetchProducts({String? category}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _products = await _apiService.getProducts(
        category: category != 'All' ? category : null,
      );
      _selectedCategory = category;
      _filteredProducts = [];
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      _filteredProducts = [];
      notifyListeners();
      return;
    }

    _filteredProducts = _products
        .where((p) =>
            p.name.toLowerCase().contains(query.toLowerCase()) ||
            p.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> createProduct(Product product) async {
    try {
      _isLoading = true;
      notifyListeners();

      final newProduct = await _apiService.createProduct(product);
      _products.add(newProduct);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateProduct(int id, Product product) async {
    try {
      _isLoading = true;
      notifyListeners();

      final updatedProduct = await _apiService.updateProduct(id, product);
      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _apiService.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchFavorites() async {
    try {
      _favorites = await _apiService.getFavorites();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(int productId) async {
    try {
      final isFavorite = _favorites.any((f) => f.productId == productId);
      
      if (isFavorite) {
        await _apiService.removeFavorite(productId);
        _favorites.removeWhere((f) => f.productId == productId);
      } else {
        await _apiService.addFavorite(productId);
        // Refresh favorites
        await fetchFavorites();
      }
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  bool isFavorite(int productId) {
    return _favorites.any((f) => f.productId == productId);
  }
}
