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
        imageUrl: 'https://via.placeholder.com/150',
        price: 20.0,
        quantity: 2),
    Product(
        name: 'Product 2',
        imageUrl: 'https://via.placeholder.com/150',
        price: 30.0,
        quantity: 1),
    Product(
        name: 'Product 3',
        imageUrl: 'https://via.placeholder.com/150',
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
        onPressed: () {
          // Add your purchase logic here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Proceeding to purchase...')),
          );
        },
        label: const Text('Proceed Purchase'),
        icon: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
