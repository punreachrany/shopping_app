import 'package:flutter/material.dart';

class Product {
  final String imageUrl;
  final String name;
  final double price;

  Product({required this.imageUrl, required this.name, required this.price});
}

class ProductGridPage extends StatefulWidget {
  @override
  _ProductGridPageState createState() => _ProductGridPageState();
}

class _ProductGridPageState extends State<ProductGridPage> {
  final List<Product> products = List.generate(
    20,
    (index) => Product(
      name: 'Product $index',
      imageUrl:
          'https://static.vecteezy.com/system/resources/previews/036/324/708/large_2x/ai-generated-picture-of-a-tiger-walking-in-the-forest-photo.jpg',
      price: (index + 1) * 10.0,
    ),
  );

  final ScrollController _scrollController = ScrollController();
  List<Product> displayedProducts = [];
  bool isLoading = false; // To show loading indicator
  int itemsPerPage = 8;

  @override
  void initState() {
    super.initState();
    _loadMoreProducts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading) {
        _loadMoreProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreProducts() async {
    setState(() {
      isLoading = true; // Start loading
    });

    // Simulate a network request delay
    await Future.delayed(const Duration(seconds: 2));

    final int currentLength = displayedProducts.length;
    final int nextLength = currentLength + itemsPerPage;

    if (currentLength < products.length) {
      setState(() {
        displayedProducts.addAll(
          products.sublist(
            currentLength,
            nextLength > products.length ? products.length : nextLength,
          ),
        );
      });
    }

    setState(() {
      isLoading = false; // Stop loading
    });
  }

  void _addProduct() {
    setState(() {
      products.add(
        Product(
          imageUrl:
              'https://static.vecteezy.com/system/resources/previews/036/324/708/large_2x/ai-generated-picture-of-a-tiger-walking-in-the-forest-photo.jpg',
          name: 'New Product',
          price: 99.99,
        ),
      );
    });
  }

  void _removeProduct(int index) {
    setState(() {
      displayedProducts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Grid'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addProduct,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: displayedProducts.length,
              itemBuilder: (context, index) {
                final product = displayedProducts[index];
                return ProductCard(
                  product: product,
                  onRemove: () => _removeProduct(index),
                );
              },
            ),
          ),
          if (isLoading) // Show loading indicator
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;

  const ProductCard({required this.product, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ),
          TextButton(
            onPressed: onRemove,
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
