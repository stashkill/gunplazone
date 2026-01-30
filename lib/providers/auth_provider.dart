import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  // Private variables
  String? _email;
  String? _userId;
  String? _userName;
  String? _userRole; // 'user' atau 'admin'
  String? _token; // Token autentikasi
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  // Getters
  String? get email => _email;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userRole => _userRole;
  String? get token => _token;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAdmin => _userRole == 'admin';

  AuthProvider() {
    _checkAuthStatus();
  }

  // Check auth status dari SharedPreferences
  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('email');
      final savedUserName = prefs.getString('userName');
      final savedUserRole = prefs.getString('userRole');
      final savedUserId = prefs.getString('userId');
      final savedToken = prefs.getString('token');

      if (savedEmail != null) {
        _email = savedEmail;
        _userName = savedUserName ?? 'User';
        _userRole = savedUserRole ?? 'user';
        _userId = savedUserId ?? savedEmail;
        _token = savedToken;
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      print('Auth check error: $e');
    }
  }

  // Set email
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  // Set user info - IMPORTANT: This sets _isAuthenticated to true
  void setUser(String email, String name, {String role = 'user', String? userId, String? token}) {
    _email = email;
    _userName = name;
    _userRole = role;
    _userId = userId ?? email;
    _token = token ?? 'dummy_token_${email}'; // Gunakan dummy token jika tidak ada
    _isAuthenticated = true; // ✅ CRITICAL: Set to true when user logs in
    _error = null;

    // Save to SharedPreferences
    _saveUserToPrefs();

    print('✅ User authenticated: $_isAuthenticated, email: $_email');
    notifyListeners();
  }

  // Save user to SharedPreferences
  Future<void> _saveUserToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', _email ?? '');
      await prefs.setString('userName', _userName ?? 'User');
      await prefs.setString('userRole', _userRole ?? 'user');
      await prefs.setString('userId', _userId ?? '');
      await prefs.setString('token', _token ?? '');
    } catch (e) {
      print('Save user error: $e');
    }
  }

  // Set user role
  void setUserRole(String role) {
    _userRole = role;
    _saveUserToPrefs();
    notifyListeners();
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Login dengan email
  Future<bool> loginWithEmail(String email, String name) async {
    try {
      setLoading(true);
      _error = null;

      // Validasi email
      if (email.isEmpty) {
        _error = 'Email cannot be empty';
        setLoading(false);
        return false;
      }

      // Simulasi API call
      await Future.delayed(const Duration(seconds: 1));

      // Set user info
      setUser(email, name, role: 'user');

      setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      setLoading(false);
      print('Login error: $e');
      return false;
    }
  }

  // Login dengan Google
  Future<bool> loginWithGoogle() async {
    try {
      setLoading(true);
      _error = null;

      // TODO: Implement Firebase Google Sign In
      // Untuk sekarang, gunakan dummy data
      await Future.delayed(const Duration(seconds: 1));

      setUser(
        'user@gmail.com',
        'Google User',
        role: 'user',
        userId: 'google_user_123',
      );

      setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      setLoading(false);
      print('Google login error: $e');
      return false;
    }
  }

  // Login dengan Apple
  Future<bool> loginWithApple() async {
    try {
      setLoading(true);
      _error = null;

      // TODO: Implement Sign In with Apple
      // Untuk sekarang, gunakan dummy data
      await Future.delayed(const Duration(seconds: 1));

      setUser(
        'user@apple.com',
        'Apple User',
        role: 'user',
        userId: 'apple_user_123',
      );

      setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      setLoading(false);
      print('Apple login error: $e');
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      setLoading(true);

      // Delete from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('userName');
      await prefs.remove('userRole');
      await prefs.remove('userId');
      await prefs.remove('token');

      _email = null;
      _userId = null;
      _userName = null;
      _userRole = null;
      _token = null;
      _isAuthenticated = false;
      _error = null;

      setLoading(false);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      setLoading(false);
      print('Logout error: $e');
    }
  }

  // Check if user is logged in
  bool isUserLoggedIn() {
    return _isAuthenticated && _email != null;
  }

  // Get user info as map
  Map<String, dynamic> getUserInfo() {
    return {
      'email': _email,
      'userId': _userId,
      'userName': _userName,
      'userRole': _userRole,
      'isAuthenticated': _isAuthenticated,
    };
  }

  // Update user name
  void updateUserName(String name) {
    _userName = name;
    _saveUserToPrefs();
    notifyListeners();
  }

  // Update user role (admin only)
  void updateUserRole(String role) {
    _userRole = role;
    _saveUserToPrefs();
    notifyListeners();
  }

  // Clear all data
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _email = null;
      _userId = null;
      _userName = null;
      _userRole = null;
      _isAuthenticated = false;
      _isLoading = false;
      _error = null;

      notifyListeners();
    } catch (e) {
      print('Clear all error: $e');
    }
  }

  // Set error
  void setError(String error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
