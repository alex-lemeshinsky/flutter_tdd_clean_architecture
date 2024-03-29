import 'package:tdd_example/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tdd_example/core/usecases/usecase.dart';
import 'package:tdd_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_example/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository _repository;

  GetRandomNumberTrivia(this._repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(params) async {
    return await _repository.getRandomNumberTrivia();
  }
}
