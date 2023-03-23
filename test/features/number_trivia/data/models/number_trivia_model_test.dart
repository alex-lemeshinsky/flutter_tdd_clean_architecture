import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_example/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_example/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(
    number: 10,
    text: "10 is greater than 9",
  );
  const tNumberTriviaModelDouble = NumberTriviaModel(
    number: 10.0,
    text: "10.0 is greater than 9",
  );

  test(
    "should be a subclass of NumberTrivia entity",
    () {
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group(
    "fromJson",
    () {
      test(
        "should return a valid model when the Json number is an integer",
        () {
          final Map<String, dynamic> jsonMap =
              jsonDecode(fixture("trivia.json"));
          final result = NumberTriviaModel.fromJson(jsonMap);

          expect(result, tNumberTriviaModel);
        },
      );

      test(
        "should return a valid model when the Json number is a double",
        () {
          final Map<String, dynamic> jsonMap =
              jsonDecode(fixture("trivia_double.json"));
          final result = NumberTriviaModel.fromJson(jsonMap);

          expect(result, tNumberTriviaModelDouble);
        },
      );
    },
  );

  group(
    "toJson",
    () {
      test(
        "should return a Json map containing the proper data",
        () {
          final Map<String, dynamic> jsonMap =
              jsonDecode(fixture("trivia.json"));
          final result = NumberTriviaModel.fromJson(jsonMap);

          expect(result, tNumberTriviaModel);
        },
      );

      test(
        "should return a valid model when the Json number is a double",
        () {
          final Map<String, dynamic> jsonMap = {
            "text": "10 is greater than 9",
            "number": 10
          };
          final result = tNumberTriviaModel.toJson();

          expect(result, jsonMap);
        },
      );
    },
  );
}
