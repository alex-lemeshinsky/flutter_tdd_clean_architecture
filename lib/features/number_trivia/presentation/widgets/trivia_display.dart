import 'package:flutter/material.dart';
import 'package:tdd_example/features/number_trivia/domain/entities/number_trivia.dart';

class TriviaDisplay extends StatelessWidget {
  const TriviaDisplay({super.key, required this.numberTrivia});

  final NumberTrivia numberTrivia;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          numberTrivia.number.toString(),
          style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        ),
        Text(
          numberTrivia.text,
          style: const TextStyle(fontSize: 25),
        ),
      ],
    );
  }
}
