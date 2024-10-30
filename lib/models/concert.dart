class Concert {
  final int id;
  final String name;
  final String description;
  final String venue;
  final DateTime dateTime;
  final int seats;
  final double price;
  final String imageUrl;

  Concert({
    required this.id,
    required this.name,
    required this.description,
    required this.venue,
    required this.dateTime,
    required this.seats,
    required this.price,
    required this.imageUrl,
  });

  factory Concert.fromJson(Map<String, dynamic> json) {
    return Concert(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      venue: json['venue'],
      dateTime: DateTime.parse(json['date_time']),
      seats: json['seats'],
      price: json['price'].toDouble(),
      imageUrl: json['image_url'],
    );
  }
}

class Booking {
  final Concert concert;
  final int numSeats;

  Booking({required this.concert, required this.numSeats});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      concert: Concert.fromJson(json['concert']),
      numSeats: json['num_seats'],
    );
  }
}
