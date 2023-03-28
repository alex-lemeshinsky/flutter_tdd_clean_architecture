import 'package:dartz/dartz.dart';
import 'package:tdd_example/core/error/failures.dart';

class InputConverter {
  Either<Failure, num> stringToUnsignedInteger(String str) {
    try {
      final number = num.parse(str);

      if (number < 0) return Left(InvalidInputFailure());

      return Right(number);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
