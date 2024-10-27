import 'package:flutter/material.dart';

class Product {
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });
}

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // Sample product list
  List<Product> orders = [
    Product(
        name: 'Product 1',
        imageUrl:
            'https://static.vecteezy.com/system/resources/previews/036/324/708/large_2x/ai-generated-picture-of-a-tiger-walking-in-the-forest-photo.jpg',
        price: 20.0,
        quantity: 2),
    Product(
        name: 'Product 2',
        imageUrl:
            'https://static.vecteezy.com/system/resources/previews/036/324/708/large_2x/ai-generated-picture-of-a-tiger-walking-in-the-forest-photo.jpg',
        price: 30.0,
        quantity: 1),
    Product(
        name: 'Product 3',
        imageUrl:
            'https://static.vecteezy.com/system/resources/previews/036/324/708/large_2x/ai-generated-picture-of-a-tiger-walking-in-the-forest-photo.jpg',
        price: 50.0,
        quantity: 3),
  ];

  // Calculate total price
  double get totalPrice {
    return orders.fold(
      0.0,
      (sum, product) => sum + (product.price * product.quantity),
    );
  }

  // Update product quantity
  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      orders[index].quantity = newQuantity;
    });
  }

  // Show purchase result dialog
  void _showPurchaseDialog(bool success) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(success ? 'Success' : 'Failed'),
          content: Text(success
              ? 'Your purchase was successful!'
              : 'Your purchase could not be completed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Proceed with the purchase
  void _proceedPurchase() {
    // You can implement your purchase logic here
    bool purchaseSuccessful = true; // Simulate success/failure

    // Show the dialog with purchase result
    _showPurchaseDialog(purchaseSuccessful);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final product = orders[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.network(
                      product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.name),
                    subtitle:
                        Text('Price: \$${product.price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (product.quantity > 1) {
                              _updateQuantity(index, product.quantity - 1);
                            }
                          },
                        ),
                        Text('${product.quantity}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            _updateQuantity(index, product.quantity + 1);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _proceedPurchase,
        label: const Text('Proceed Purchase'),
        icon: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
