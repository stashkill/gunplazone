import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late TextEditingController _addressController;
  String _selectedDelivery = 'Standard';
  String _selectedPayment = 'Credit Card';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handlePlaceOrder(
  BuildContext context,
  CartProvider cartProvider,
) async {
  debugPrint('HANDLE PLACE ORDER CALLED');

  if (_addressController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter shipping address')),
    );
    return;
  }

  setState(() => _isProcessing = true);

  try {
    final url = Uri.parse('http://localhost:3000/api/orders');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "userId": 2,
        'items': cartProvider.items.map((e) => {
          'productId': e.product.id,
          'qty': e.quantity,
          'price': e.product.price,
        }).toList(),
        'totalAmount': cartProvider.totalPrice,
        'shippingAddress': _addressController.text,
        'deliveryOption': _selectedDelivery,
        'paymentMethod': _selectedPayment,
      }),
    );

    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      cartProvider.clearCart();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/home/orders');
    } else {
      throw Exception('Failed to place order');
    }
  } catch (e) {
    debugPrint('ERROR PLACE ORDER: $e');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  } finally {
    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer2<CartProvider, AuthProvider>(
        builder: (context, cartProvider, authProvider, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shipping Address
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SHIPPING',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          hintText: 'Enter shipping address',
                          labelText: 'Shipping Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      // Delivery Options
                      Text(
                        'DELIVERY',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('Standard (Free)'),
                            value: 'Standard',
                            groupValue: _selectedDelivery,
                            onChanged: (value) {
                              setState(() => _selectedDelivery = value ?? 'Standard');
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('Express (Rp 50.000)'),
                            value: 'Express',
                            groupValue: _selectedDelivery,
                            onChanged: (value) {
                              setState(() => _selectedDelivery = value ?? 'Express');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Payment Method
                      Text(
                        'PAYMENT',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('Credit Card'),
                            value: 'Credit Card',
                            groupValue: _selectedPayment,
                            onChanged: (value) {
                              setState(() => _selectedPayment = value ?? 'Credit Card');
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('Bank Transfer'),
                            value: 'Bank Transfer',
                            groupValue: _selectedPayment,
                            onChanged: (value) {
                              setState(() => _selectedPayment = value ?? 'Bank Transfer');
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('E-Wallet'),
                            value: 'E-Wallet',
                            groupValue: _selectedPayment,
                            onChanged: (value) {
                              setState(() => _selectedPayment = value ?? 'E-Wallet');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Order Summary
                      Text(
                        'ORDER SUMMARY',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Items
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartProvider.items.length,
                        itemBuilder: (context, index) {
                          final item = cartProvider.items[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.product.name} x${item.quantity}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                Text(
                                  'Rp ${item.product.price}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
                          Text(cartProvider.formattedTotal, style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Shipping', style: Theme.of(context).textTheme.bodyMedium),
                          Text(
                            _selectedDelivery == 'Standard' ? 'Free' : 'Rp 50.000',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Taxes', style: Theme.of(context).textTheme.bodyMedium),
                          Text('Rp ${(cartProvider.totalPrice * 0.1).toInt()}', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rp ${(cartProvider.totalPrice + (cartProvider.totalPrice * 0.1).toInt()).toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Place Order Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isProcessing ? null : () => _handlePlaceOrder(context, cartProvider),
                          child: _isProcessing
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : const Text('Place Order'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
