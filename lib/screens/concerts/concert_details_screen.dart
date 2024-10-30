import 'package:flutter/material.dart';
import 'package:shopping_app/models/concert.dart';
import 'package:shopping_app/services/api_service.dart';

class ConcertDetailsScreen extends StatefulWidget {
  final int concertId;

  const ConcertDetailsScreen({Key? key, required this.concertId})
      : super(key: key);

  @override
  _ConcertDetailsScreenState createState() => _ConcertDetailsScreenState();
}

class _ConcertDetailsScreenState extends State<ConcertDetailsScreen> {
  final ApiService apiService = ApiService();
  late Future<Concert> concert;
  int selectedSeats = 0; // Seat counter

  @override
  void initState() {
    super.initState();
    concert = apiService.fetchConcertDetails(widget.concertId);
  }

  Future<void> _bookConcert(int numSeats) async {
    try {
      final response = await apiService.bookConcert(widget.concertId, numSeats);
      // print()
      _showBookingDialog(response);
    } catch (error) {
      print("Error : $error");
      _showErrorDialog();
    }
  }

  void _showBookingDialog(Map<String, dynamic> bookingData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Booking Confirmed: ${bookingData["concert_name"]}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price per Ticket: \$${bookingData["price_per_ticket"]}'),
              Text('Total Price: \$${bookingData["total_price"]}'),
              Text('Date: ${bookingData["date"]}'),
              Text('Booking ID: ${bookingData["booking_id"]}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.popUntil(
                  context, (route) => route.isFirst), // Go back to list
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Booking Failed'),
          content: const Text('Unable to complete the booking.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Concert Details'),
      ),
      body: FutureBuilder<Concert>(
        future: concert,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load concert: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No concert found.'));
          } else {
            final concert = snapshot.data!;
            return _buildConcertDetails(concert);
          }
        },
      ),
    );
  }

  Widget _buildConcertDetails(Concert concert) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Concert Image
          Image.network(
            concert.imageUrl,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),

          // Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              concert.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Venue & Date
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '${concert.venue} | ${concert.dateTime.toLocal()}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Price & Available Seats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${concert.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  '${concert.seats} seats available',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              concert.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
          const SizedBox(height: 24),

          // Seat Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Number of Seats:',
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (selectedSeats > 0) {
                          setState(() {
                            selectedSeats--;
                          });
                        }
                      },
                    ),
                    Text(
                      selectedSeats.toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          selectedSeats++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Book Button
          Center(
            child: ElevatedButton(
              onPressed: selectedSeats > 0
                  ? () => _bookConcert(selectedSeats)
                  : null, // Disable if no seats selected
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 12.0,
                ),
              ),
              child: const Text(
                'Book This Concert',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
