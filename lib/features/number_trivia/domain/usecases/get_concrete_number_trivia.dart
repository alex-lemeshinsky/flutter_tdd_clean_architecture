import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_example/core/error/failures.dart';
import 'package:tdd_example/core/usecases/usecase.dart';
import 'package:tdd_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_example/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository _repository;

  GetConcreteNumberTrivia(this._repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await _repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
