import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:tdd_example/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_example/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

const int tNumber = 1;
const NumberTrivia tNumberTrivia = NumberTrivia(number: 1, text: "text");

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

@GenerateMocks([MockNumberTriviaRepository])
void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  test(
    "should get trivia for the number from the repository",
    () async {
      when(
        mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber),
      ).thenAnswer(
        (realInvocation) async => const Right(tNumberTrivia),
      );

      final result = await usecase(number: tNumber);

      expect(result, const Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
