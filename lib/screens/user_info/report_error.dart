import 'package:flutter/material.dart';
import 'package:shopping_app/services/api_service.dart'; // Adjust the import based on your directory structure

class ReportErrorScreen extends StatefulWidget {
  const ReportErrorScreen({super.key});

  @override
  _ReportErrorScreenState createState() => _ReportErrorScreenState();
}

class _ReportErrorScreenState extends State<ReportErrorScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false; // To manage loading state

  void _submitErrorReport() async {
    String message = _messageController.text;

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an error message.')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    bool success = await _apiService.sendInquiry('Error Report', message);

    setState(() {
      _isLoading = false; // Hide loading indicator
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error report submitted successfully!')),
      );
      Navigator.pop(context); // Navigate back to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit error report.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Error'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Describe the error:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter error details here...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : _submitErrorReport, // Disable button while loading
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                  : const Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}
