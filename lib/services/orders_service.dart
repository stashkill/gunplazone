import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrdersService {
  static const baseUrl = 'http://localhost:3000/api';

  static Future<List<Order>> fetchOrders(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load orders');
    }

    final body = json.decode(response.body);
    final List data = body['data'];

    return data.map((e) => Order.fromJson(e)).toList();
  }
}
