class Order {
  final int id;
  final int totalAmount;
  final String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      totalAmount: json['totalAmount'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
