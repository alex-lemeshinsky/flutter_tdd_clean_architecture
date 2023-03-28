import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_example/const.dart';
import 'package:tdd_example/core/usecases/usecase.dart';
import 'package:tdd_example/core/util/input_converter.dart';
import 'package:tdd_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_example/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_example/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(const Empty()) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
  }

  void _onGetTriviaForConcreteNumber(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);

    inputEither.fold(
      (l) => emit(const Error(message: invalidInputFailureMessage)),
      (number) async {
        emit(const Loading());

        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: number));

        emit(
          failureOrTrivia.fold(
            (failure) => Error(message: failure.toString()),
            (trivia) => Loaded(trivia: trivia),
          ),
        );
      },
    );
  }

  void _onGetTriviaForRandomNumber(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(const Loading());

    final failureOrTrivia = await getRandomNumberTrivia(NoParams());

    emit(
      failureOrTrivia.fold(
        (failure) => Error(message: failure.toString()),
        (trivia) => Loaded(trivia: trivia),
      ),
    );
  }
}
