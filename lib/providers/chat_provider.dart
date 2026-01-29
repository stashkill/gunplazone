import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class ChatProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with mock messages
  ChatProvider() {
    _loadMockMessages();
  }

  // Load mock messages (fallback)
  void _loadMockMessages() {
    _messages = [
      {
        'id': 1,
        'userId': 0,
        'userName': 'Support',
        'message': 'Hello! How can we help you today?',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)).toString(),
        'isUserMessage': false,
      },
      {
        'id': 2,
        'userId': 1,
        'userName': 'You',
        'message': 'Hi! I have a question about my order.',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 3)).toString(),
        'isUserMessage': true,
      },
      {
        'id': 3,
        'userId': 0,
        'userName': 'Support',
        'message': 'Sure! What is your order number?',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 2)).toString(),
        'isUserMessage': false,
      },
    ];
  }

  // Fetch messages from API
  Future<void> fetchMessages() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // For now, we'll use mock data since the API doesn't have a get messages endpoint
      // In production, you would call: await _apiService.getMessages();
      _loadMockMessages();
    } catch (e) {
      _error = 'Failed to fetch messages: $e';
      print('Error fetching messages: $e');
      _loadMockMessages();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add message locally
  void addMessage({
    required int userId,
    required String userName,
    required String message,
  }) {
    _messages.add({
      'id': _messages.length + 1,
      'userId': userId,
      'userName': userName,
      'message': message,
      'timestamp': DateTime.now().toString(),
      'isUserMessage': true,
    });

    // Simulate support response after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      _messages.add({
        'id': _messages.length + 1,
        'userId': 0,
        'userName': 'Support',
        'message': 'Thanks for your message! We will respond shortly.',
        'timestamp': DateTime.now().toString(),
        'isUserMessage': false,
      });
      notifyListeners();
    });

    notifyListeners();
  }

  // Send message to API
  Future<bool> sendMessage(String message, int userId) async {
    _error = null;

    try {
      // Add message locally first
      addMessage(
        userId: userId,
        userName: 'You',
        message: message,
      );
      return true;
    } catch (e) {
      _error = 'Failed to send message: $e';
      print('Error sending message: $e');
      return false;
    }
  }

  // Clear messages
  void clearMessages() {
    _messages = [];
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
