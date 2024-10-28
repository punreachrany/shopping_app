class Product {
  static const List<String> categoryChoices = [
    'Foods',
    'Clothes',
    'Electronics',
    'Other',
  ];

  final String name;
  final double price;
  final String description;
  final int quantity;
  final String category;
  final bool outOfStock;
  final String? imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.quantity,
    required this.category,
    this.outOfStock = false,
    this.imageUrl,
  });

  // Method to convert a JSON object to a Product instance
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
      quantity: json['quantity'],
      category: json['category'],
      outOfStock: json['out_of_stock'] ?? false,
      imageUrl: json['image_url'],
    );
  }

  // Method to convert a Product instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'quantity': quantity,
      'category': category,
      'out_of_stock': outOfStock,
      'image_url': imageUrl,
    };
  }
}
