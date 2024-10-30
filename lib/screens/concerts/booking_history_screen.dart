import 'package:flutter/material.dart';
import 'package:shopping_app/models/concert.dart';
import 'package:shopping_app/services/api_service.dart';

class BookingHistoryScreen extends StatefulWidget {
  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  late Future<List<Booking>> _bookings;

  @override
  void initState() {
    super.initState();
    _bookings = ApiService().fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Concert Booking History'),
      ),
      body: FutureBuilder<List<Booking>>(
        future: _bookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          }

          final bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final concert = booking.concert;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.network(
                    concert.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/placeholder.jpg', // Replace with your local placeholder image
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  title: Text(concert.name),
                  subtitle: Text(
                    '${concert.dateTime.toLocal()} at ${concert.venue}\nSeats: ${booking.numSeats}',
                  ),
                  trailing: Text('\$${concert.price * booking.numSeats}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
