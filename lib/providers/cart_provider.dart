import 'package:flutter/material.dart';
import '../models/models.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  int get totalPrice => _items.fold(0, (sum, item) => sum + item.subtotal);

  String get formattedTotal {
    return 'Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}';
  }

  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        id: DateTime.now().millisecondsSinceEpoch,
        product: product,
        quantity: quantity,
      ));
    }
    
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  Order createOrder({
    required int userId,
    required String shippingAddress,
    required String deliveryOption,
    required String paymentMethod,
  }) {
    return Order(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: userId,
      items: _items,
      totalAmount: totalPrice,
      status: 'pending',
      shippingAddress: shippingAddress,
      deliveryOption: deliveryOption,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
    );
  }
}
