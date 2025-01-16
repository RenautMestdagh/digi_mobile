import 'package:flutter/material.dart';

class MailAuthScreen extends StatefulWidget {
  final int selectedVerificationMethod;

  const MailAuthScreen({
    super.key,
    required this.selectedVerificationMethod, // Mark as required
  });

  @override
  State<MailAuthScreen> createState() => _MailAuthScreenState();
}

class _MailAuthScreenState extends State<MailAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Selected verification method: ${widget.selectedVerificationMethod}",
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
