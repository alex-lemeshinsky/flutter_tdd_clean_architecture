import 'package:tdd_example/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({required super.number, required super.text});

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      number: json["number"] as num,
      text: json["text"] as String,
    );
  }

  Map<String, dynamic> toJson() => {"text": text, "number": number};
}
