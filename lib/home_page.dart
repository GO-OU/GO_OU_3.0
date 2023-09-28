import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final TextEditingController _feedbackController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> _submitFeedback() async {
    String feedback = _feedbackController.text;

    if (feedback.isNotEmpty) {
      // Send feedback to server
      try {
        var response = await http.post(
          Uri.parse('http://localhost:8080/submit-feedback'),
          body: {'feedback': feedback},
        );

        if (response.statusCode == 200) {
          _showSnackBar('Thank you for your feedback!');
          _feedbackController.clear();
        } else {
          _showSnackBar('Failed to submit feedback.');
        }
      } catch (error) {
        _showSnackBar('An error occurred: $error');
      }
    } else {
      _showSnackBar('Please provide feedback before submitting.');
    }
  }

  void _showSnackBar(String message) {
    final scaffoldMessengerState = _scaffoldKey.currentState;
    if (scaffoldMessengerState != null) {
      scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(message)),
      );
    } else {
      print('Failed to show snackbar. ScaffoldMessengerState is null.');
    }

  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView ( // allows scrolling when keyboard is up?
          child: Center (
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _feedbackController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Share your thoughts on using GO-OU',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitFeedback,
                  child: const Text('Submit Feedback'),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}