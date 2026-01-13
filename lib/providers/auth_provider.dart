import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAdmin => _user?.role == 'admin';

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userJson = prefs.getString('user');
      
      if (token != null && userJson != null) {
        _isAuthenticated = true;
        _user = User.fromJson(Map<String, dynamic>.from(
          (userJson as Map).cast<String, dynamic>(),
        ));
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> loginWithGoogle(String idToken) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.loginWithGoogle(idToken);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', response['token']);
      
      _user = User.fromJson(response['user']);
      _isAuthenticated = true;
      
      await prefs.setString('user', _user.toString());
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _apiService.logout();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user');
      
      _user = null;
      _isAuthenticated = false;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
