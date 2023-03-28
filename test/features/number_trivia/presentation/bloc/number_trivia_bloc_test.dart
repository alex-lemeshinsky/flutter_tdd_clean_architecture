import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_example/const.dart';
import 'package:tdd_example/core/error/failures.dart';
import 'package:tdd_example/core/usecases/usecase.dart';
import 'package:tdd_example/core/util/input_converter.dart';
import 'package:tdd_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_example/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_example/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:tdd_example/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import '../../data/repositories/number_trivia_repository_impl_test.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test(
    "initialState should be Empty",
    () => expect(bloc.state, equals(const Empty())),
  );

  group(
    "GetTriviaForConcreteNumber",
    () {
      const String tNumberString = "1";
      const int tNumberParsed = 1;
      const NumberTrivia tNumberTrivia = NumberTrivia(number: 1, text: "text");

      void setUpMockInputConverterSuccess() {
        when(
          () => mockInputConverter.stringToUnsignedInteger(tNumberString),
        ).thenReturn(const Right(tNumberParsed));
      }

      void setUpMockGetConcreteNumberTriviaSuccess() {
        when(
          () => mockGetConcreteNumberTrivia(
            const Params(number: tNumberParsed),
          ),
        ).thenAnswer((invocation) async => const Right(tNumberTrivia));
      }

      test(
        "should call the InputConverter to validate and convert the string to num",
        () async {
          setUpMockInputConverterSuccess();
          setUpMockGetConcreteNumberTriviaSuccess();

          bloc.add(const GetTriviaForConcreteNumber(tNumberString));

          await untilCalled(
            () => mockInputConverter.stringToUnsignedInteger(tNumberString),
          );

          verify(
            () => mockInputConverter.stringToUnsignedInteger(tNumberString),
          );
        },
      );

      test(
        "should emit [Error] when the input is invalid",
        () {
          when(
            () => mockInputConverter.stringToUnsignedInteger(tNumberString),
          ).thenReturn(Left(InvalidInputFailure()));

          final expected = [const Error(message: invalidInputFailureMessage)];
          expectLater(bloc.stream, emitsInOrder(expected));

          bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        },
      );

      test(
        "should get data from the concrete use case",
        () async {
          setUpMockInputConverterSuccess();
          setUpMockGetConcreteNumberTriviaSuccess();

          bloc.add(const GetTriviaForConcreteNumber(tNumberString));

          await untilCalled(
            () => mockGetConcreteNumberTrivia(
              const Params(number: tNumberParsed),
            ),
          );

          verify(
            () => mockGetConcreteNumberTrivia(
              const Params(number: tNumberParsed),
            ),
          );
        },
      );

      test(
        "should emit [Loading, Loaded] when data is gotten successfully",
        () {
          setUpMockInputConverterSuccess();
          setUpMockGetConcreteNumberTriviaSuccess();

          final expected = [
            const Loading(),
            const Loaded(trivia: tNumberTrivia),
          ];
          expectLater(bloc.stream, emitsInOrder(expected));

          bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        },
      );

      test(
        "should emit [Loading, Error] when getting data fails",
        () {
          setUpMockInputConverterSuccess();
          when(
            () => mockGetConcreteNumberTrivia(
              const Params(number: tNumberParsed),
            ),
          ).thenAnswer((invocation) async => Left(ServerFailure()));

          final expected = [
            const Loading(),
            const Error(message: serverFailureMessage),
          ];
          expectLater(bloc.stream, emitsInOrder(expected));

          bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        },
      );

      test(
        "should emit [Loading, Error] with a proper message when getting data fails",
        () {
          setUpMockInputConverterSuccess();
          when(
            () => mockGetConcreteNumberTrivia(
              const Params(number: tNumberParsed),
            ),
          ).thenAnswer((invocation) async => Left(CacheFailure()));

          final expected = [
            const Loading(),
            const Error(message: cacheFailureMessage),
          ];
          expectLater(bloc.stream, emitsInOrder(expected));

          bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        },
      );
    },
  );

  group(
    "GetTriviaForRandomNumber",
    () {
      const String tNumberString = "1";
      const int tNumberParsed = 1;
      const NumberTrivia tNumberTrivia = NumberTrivia(number: 1, text: "text");

      void setUpMockGetRandomNumberTriviaSuccess() {
        when(() => mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((invocation) async => const Right(tNumberTrivia));
      }

      test(
        "should get data from the concrete use case",
        () async {
          setUpMockGetRandomNumberTriviaSuccess();

          bloc.add(const GetTriviaForRandomNumber());

          await untilCalled(
            () => mockGetRandomNumberTrivia(NoParams()),
          );

          verify(() => mockGetRandomNumberTrivia(NoParams()));
        },
      );

      test(
        "should emit [Loading, Loaded] when data is gotten successfully",
        () {
          setUpMockGetRandomNumberTriviaSuccess();

          final expected = [
            const Loading(),
            const Loaded(trivia: tNumberTrivia),
          ];
          expectLater(bloc.stream, emitsInOrder(expected));

          bloc.add(const GetTriviaForRandomNumber());
        },
      );

      test(
        "should emit [Loading, Error] when getting data fails",
        () {
          when(
            () => mockGetRandomNumberTrivia(NoParams()),
          ).thenAnswer((invocation) async => Left(ServerFailure()));

          final expected = [
            const Loading(),
            const Error(message: serverFailureMessage),
          ];
          expectLater(bloc.stream, emitsInOrder(expected));

          bloc.add(const GetTriviaForRandomNumber());
        },
      );

      test(
        "should emit [Loading, Error] with a proper message when getting data fails",
        () {
          when(
            () => mockGetRandomNumberTrivia(NoParams()),
          ).thenAnswer((invocation) async => Left(CacheFailure()));

          final expected = [
            const Loading(),
            const Error(message: cacheFailureMessage),
          ];
          expectLater(bloc.stream, emitsInOrder(expected));

          bloc.add(const GetTriviaForRandomNumber());
        },
      );
    },
  );
}
