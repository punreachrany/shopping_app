import 'package:flutter/material.dart';

class Product {
  final String imageUrl;
  final String name;
  final double price;
  final String description;

  Product({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.description,
  });
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return ProductDetailsPage(
      product: Product(
        imageUrl:
            'https://static.vecteezy.com/system/resources/previews/036/324/708/large_2x/ai-generated-picture-of-a-tiger-walking-in-the-forest-photo.jpg',
        name: 'Sample Product',
        price: 49.99,
        description:
            'This is a detailed description of the product. It includes all the features and specifications to help you make a better purchase decision.',
      ),
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int numberOfOrders = 0;

  void _incrementOrder() {
    setState(() {
      numberOfOrders++;
    });
  }

  void _decrementOrder() {
    if (numberOfOrders > 0) {
      setState(() {
        numberOfOrders--;
      });
    }
  }

  void _placeOrder() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order placed for $numberOfOrders items!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Image.network(
              widget.product.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),

            // Product Name
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Product Price
            Text(
              '\$${widget.product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),

            // Number of Orders (Selectable Buttons)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _decrementOrder,
                ),
                Text(
                  '$numberOfOrders',
                  style: const TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _incrementOrder,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Orders',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Product Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),

            // Order Button
            Center(
              child: ElevatedButton(
                onPressed: numberOfOrders > 0 ? _placeOrder : null,
                child: const Text(
                  'Place Order',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
