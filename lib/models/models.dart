// User Model
class User {
  final int id;
  final String email;
  final String? name;
  final String role; // 'user' or 'admin'
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    this.name,
    required this.role,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String?,
      role: json['role'] as String? ?? 'user',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// Product Model
class Product {
  final int id;
  final String name;
  final String description;
  final String category;
  final int price; // Harga dalam Rupiah
  final String imageUrl;
  final int stock;
  final double rating;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.stock,
    this.rating = 0.0,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Helper function to convert dynamic to int
    int _toInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is double) return value.toInt();
      return 0;
    }

    // Helper function to convert dynamic to double
    double _toDouble(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return Product(
      id: _toInt(json['id']),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: _toInt(json['price']),
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String? ?? '',
      stock: _toInt(json['stock']),
      rating: _toDouble(json['rating'] ?? 0.0),
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'stock': stock,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get formattedPrice {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}';
  }
}

// Cart Item Model
class CartItem {
  final int id;
  final Product product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  int get subtotal => product.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as int,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}

// Order Model
class Order {
  final int id;
  final int userId;
  final List<CartItem> items;
  final int totalAmount;
  final String status; // 'pending', 'shipped', 'delivered'
  final String shippingAddress;
  final String deliveryOption;
  final String paymentMethod;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.deliveryOption,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      userId: json['userId'] as int,
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
      totalAmount: json['totalAmount'] as int,
      status: json['status'] as String? ?? 'pending',
      shippingAddress: json['shippingAddress'] as String? ?? '',
      deliveryOption: json['deliveryOption'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'shippingAddress': shippingAddress,
      'deliveryOption': deliveryOption,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// Chat Message Model
class ChatMessage {
  final int id;
  final int userId;
  final String message;
  final bool isUserMessage;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.message,
    required this.isUserMessage,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int,
      userId: json['userId'] as int,
      message: json['message'] as String,
      isUserMessage: json['isUserMessage'] as bool? ?? true,
      timestamp: DateTime.parse(json['timestamp'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'message': message,
      'isUserMessage': isUserMessage,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

// Favorite Model
class Favorite {
  final int id;
  final int userId;
  final int productId;
  final Product? product;
  final DateTime createdAt;

  Favorite({
    required this.id,
    required this.userId,
    required this.productId,
    this.product,
    required this.createdAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] as int,
      userId: json['userId'] as int,
      productId: json['productId'] as int,
      product: json['product'] != null ? Product.fromJson(json['product'] as Map<String, dynamic>) : null,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'product': product?.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
