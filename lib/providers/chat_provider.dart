import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class ChatProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMessages() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _messages = await _apiService.getChatMessages();
      _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String message, int userId) async {
    try {
      // Add message optimistically
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch,
        userId: userId,
        message: message,
        isUserMessage: true,
        timestamp: DateTime.now(),
      ));
      notifyListeners();

      // Send to server
      await _apiService.sendChatMessage(message);
      
      // Simulate support response after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch,
        userId: 0, // Support user
        message: 'Terima kasih atas pesan Anda. Tim support kami akan segera merespons.',
        isUserMessage: false,
        timestamp: DateTime.now(),
      ));
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
