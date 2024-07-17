import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:studierendenwerk_app/screens/home_screen.dart';

class FeedbackScreen extends StatefulWidget {
  final EventItem eventItem;
  const FeedbackScreen({super.key, required this.eventItem});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _controller = TextEditingController();

  void _sendFeedback() {
    String feedbackText = _controller.text;
    // Hier können Sie den Code hinzufügen, um das Feedback zu speichern oder zu senden.
    // Zum Beispiel: Speichern Sie das Feedback in einer Datenbank oder senden Sie es per API.

    // Leere das Textfeld
    _controller.clear();
    MotionToast.success(
            description: const Text("Feedback gesendet!"),
            title: const Text("Gesendet!"))
        .show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback geben'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Geben Sie Ihr Feedback zu: ${widget.eventItem.title}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ihr Feedback',
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: _sendFeedback,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                ),
                child: const Text('Senden'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
