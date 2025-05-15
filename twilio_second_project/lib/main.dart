import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twilio SMS Sender',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TwilioHome(),
    );
  }
}

class TwilioHome extends StatefulWidget {
  const TwilioHome({super.key});

  @override
  State<TwilioHome> createState() => _TwilioHomeState();
}

class _TwilioHomeState extends State<TwilioHome> {
  late TwilioFlutter twilioFlutter;
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _responseMessage = '';

  @override
  void initState() {
    super.initState();

    twilioFlutter = TwilioFlutter(
      accountSid: '', 
      authToken: '',  
      twilioNumber: '',
    );
  }

  Future<void> sendSMS() async {
    final toNumber = _numberController.text.trim();
    final message = _messageController.text.trim();

    if (toNumber.isEmpty || message.isEmpty) {
      setState(() {
        _responseMessage = "Please enter both phone number and message.";
      });
      return;
    }

    final response = await twilioFlutter.sendSMS(
      toNumber: toNumber,
      messageBody: message,
    );

    print('Response State: ${response.responseState}');
    print('Response Code: ${response.responseCode}');
    print('Error: ${response.errorData}');
    print('Metadata: ${response.metadata}');

    setState(() {
      _responseMessage = response.responseState == ResponseState.SUCCESS
          ? '✅ SMS Sent Successfully!'
          : '❌ Failed: ${response.errorData?.message ?? 'Unknown error'}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Twilio SMS Sender')),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          children: [
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Recipient Number (+1234567890)',
              ),
            ),
            TextField(
              controller: _messageController,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Message'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: sendSMS,
              child: const Text('Send SMS'),
            ),
            const SizedBox(height: 40),
            Text(_responseMessage),
          ],
        ),
      ),
    );
  }
}
