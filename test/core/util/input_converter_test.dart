import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_example/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() => inputConverter = InputConverter());

  group(
    "stringToUnsignedInt",
    () {
      test(
        "should return a num when the string represents an unsigned integer",
        () {
          const String str = "123";

          final result = inputConverter.stringToUnsignedInteger(str);

          expect(result, const Right(123));
        },
      );
    },
  );

  test(
    "should return a Failure when the string is not an integer",
    () {
      const String str = "abc";

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    },
  );

  test(
    "should return a Failure when the string is a negative integer",
    () {
      const String str = "-123";

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    },
  );
}
