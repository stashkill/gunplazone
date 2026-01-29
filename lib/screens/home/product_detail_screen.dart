import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../models/models.dart';
import '../../providers/cart_provider.dart';
import '../../services/api_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = _fetchProduct();
    _productFuture.catchError((e) {
      print('Product fetch error: $e');
    });
  }

  Future<Product> _fetchProduct() async {
    try {
      final response = await Dio().get('http://10.0.2.2:3000/api/products/${widget.productId}');
      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        return Product.fromJson(data);
      }
      throw Exception('Failed to load product');
    } catch (e) {
      print('Error fetching product: $e');
      throw Exception('Failed to load product: $e');
    }
  }

  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Center(
        child: Icon(Icons.image_outlined, size: 80, color: Colors.grey[400]),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image_outlined, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text('Image error', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() => _productFuture = _fetchProduct()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Theme.of(context).colorScheme.surface,
                  child: _buildProductImage(product.imageUrl),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name & Category
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text(product.category),
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                      const SizedBox(height: 16),
                      // Price
                      Text(
                        product.formattedPrice,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text('${product.rating} (120 reviews)'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Description
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      // Stock Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Stock Available',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${product.stock} items',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Quantity Selector
                      Row(
                        children: [
                          Text(
                            'Quantity',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: _quantity > 1
                                      ? () => setState(() => _quantity--)
                                      : null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    _quantity.toString(),
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: _quantity < product.stock
                                      ? () => setState(() => _quantity++)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Add to Cart Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .addToCart(product, quantity: _quantity);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to cart'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            context.pop();
                          },
                          child: const Text('Add to Cart'),
                        ),
                      ),
                      const SizedBox(height: 16),
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
