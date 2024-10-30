import 'package:flutter/material.dart';
import 'package:shopping_app/models/concert.dart';
import 'package:shopping_app/screens/concerts/concert_details_screen.dart';
import 'package:shopping_app/services/api_service.dart';
// import '../../../assets/images/placeholder.jpg';

class ConcertListScreen extends StatefulWidget {
  @override
  _ConcertListScreenState createState() => _ConcertListScreenState();
}

class _ConcertListScreenState extends State<ConcertListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Concert>> concerts;

  @override
  void initState() {
    super.initState();
    concerts = apiService.fetchAvailableConcerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Concerts'),
      ),
      body: FutureBuilder<List<Concert>>(
        future: concerts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load concerts: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No concerts available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final concert = snapshot.data![index];
                return _buildConcertCard(concert);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onAddConcertPressed();
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Concert',
      ),
    );
  }

  void _onAddConcertPressed() {
    print('Add Concert button pressed');
    // TODO: Implement navigation to add concert screen
  }

  Widget _buildConcertCard(Concert concert) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConcertDetailsScreen(concertId: concert.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    concert.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        // '/Users/punreachrany/Desktop/New_Portfolio/shopping_app/assets/images/placeholder.jpg', // Replace with your local placeholder image
                        'assets/images/placeholder.jpg',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    child: Text(
                      concert.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                concert.venue,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                '\$${concert.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
