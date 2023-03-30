import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  const MessageDisplay({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(fontSize: 25),
    );
  }
}
