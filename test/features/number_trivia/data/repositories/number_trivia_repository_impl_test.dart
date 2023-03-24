import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_example/core/error/exceptions.dart';
import 'package:tdd_example/core/error/failures.dart';
import 'package:tdd_example/core/platform/network_info.dart';
import 'package:tdd_example/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_example/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_example/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_example/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_example/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

const tNumber = 1;
const tNumberTriviaModel =
    NumberTriviaModel(number: tNumber, text: "Test trivia");
const tNumberTrivia = tNumberTriviaModel;

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );

    when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
        .thenAnswer((invocation) async {});
  });

  void runTestsOnline(Function body) {
    group(
      "Device is online",
      () {
        setUp(() {
          when(() => mockNetworkInfo.isConnected)
              .thenAnswer((invocation) async => true);
        });

        body();
      },
    );
  }

  void runTestsOffline(Function body) {
    group(
      "Device is offline",
      () {
        setUp(() {
          when(() => mockNetworkInfo.isConnected)
              .thenAnswer((invocation) async => false);
        });

        body();
      },
    );
  }

  group(
    "getConcreeteNumberTrivia",
    () {
      runTestsOnline(
        () {
          test(
            "shoud check if the device is online",
            () async {
              when(() => mockNetworkInfo.isConnected)
                  .thenAnswer((invocation) async => true);
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                  .thenAnswer((invocation) async => tNumberTriviaModel);

              await repository.getConcreteNumberTrivia(tNumber);
              verify(() => mockNetworkInfo.isConnected);
            },
          );

          test(
            "should return remote data when the call to remote date source is successful",
            () async {
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                  .thenAnswer((invocation) async => tNumberTriviaModel);

              final result = await repository.getConcreteNumberTrivia(tNumber);
              verify(
                  () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              expect(result, equals(const Right(tNumberTrivia)));
            },
          );

          test(
            "should cache the data locally when the call to remote date source is successful",
            () async {
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                  .thenAnswer((invocation) async => tNumberTriviaModel);

              await repository.getConcreteNumberTrivia(tNumber);

              verify(
                () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber),
              );
              verify(
                () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
              );
            },
          );

          test(
            "should return server failure when the call to remote date source is unsuccessful",
            () async {
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                  .thenThrow(ServerException());

              final result = await repository.getConcreteNumberTrivia(tNumber);

              verify(
                () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber),
              );
              verifyZeroInteractions(mockLocalDataSource);
              expect(result, equals(Left(ServerFailure())));
            },
          );
        },
      );

      runTestsOffline(
        () {
          test(
            "should return last locally cached data when the cached data is present",
            () async {
              when(() => mockLocalDataSource.getLastNumberTrivia())
                  .thenAnswer((invocation) async => tNumberTriviaModel);

              final result = await repository.getConcreteNumberTrivia(tNumber);

              verifyZeroInteractions(mockRemoteDataSource);
              verify(() => mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(const Right(tNumberTrivia)));
            },
          );

          test(
            "should return CacheFailure when there is no data present",
            () async {
              when(() => mockLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());

              final result = await repository.getConcreteNumberTrivia(tNumber);

              verifyZeroInteractions(mockRemoteDataSource);
              verify(() => mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(Left(CacheFailure())));
            },
          );
        },
      );
    },
  );

  group(
    "getRandomNumberTrivia",
    () {
      runTestsOnline(
        () {
          test(
            "shoud check if the device is online",
            () async {
              when(() => mockNetworkInfo.isConnected)
                  .thenAnswer((invocation) async => true);
              when(() => mockRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((invocation) async => tNumberTriviaModel);

              await repository.getRandomNumberTrivia();
              verify(() => mockNetworkInfo.isConnected);
            },
          );

          test(
            "should return remote data when the call to remote date source is successful",
            () async {
              when(() => mockRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((invocation) async => tNumberTriviaModel);

              final result = await repository.getRandomNumberTrivia();
              verify(() => mockRemoteDataSource.getRandomNumberTrivia());
              expect(result, equals(const Right(tNumberTrivia)));
            },
          );

          test(
            "should cache the data locally when the call to remote date source is successful",
            () async {
              when(() => mockRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((invocation) async => tNumberTriviaModel);

              await repository.getRandomNumberTrivia();

              verify(
                () => mockRemoteDataSource.getRandomNumberTrivia(),
              );
              verify(
                () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
              );
            },
          );

          test(
            "should return server failure when the call to remote date source is unsuccessful",
            () async {
              when(() => mockRemoteDataSource.getRandomNumberTrivia())
                  .thenThrow(ServerException());

              final result = await repository.getRandomNumberTrivia();

              verify(
                () => mockRemoteDataSource.getRandomNumberTrivia(),
              );
              verifyZeroInteractions(mockLocalDataSource);
              expect(result, equals(Left(ServerFailure())));
            },
          );
        },
      );

      runTestsOffline(
        () {
          test(
            "should return last locally cached data when the cached data is present",
            () async {
              when(() => mockLocalDataSource.getLastNumberTrivia())
                  .thenAnswer((invocation) async => tNumberTriviaModel);

              final result = await repository.getRandomNumberTrivia();

              verifyZeroInteractions(mockRemoteDataSource);
              verify(() => mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(const Right(tNumberTrivia)));
            },
          );

          test(
            "should return CacheFailure when there is no data present",
            () async {
              when(() => mockLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());

              final result = await repository.getRandomNumberTrivia();

              verifyZeroInteractions(mockRemoteDataSource);
              verify(() => mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(Left(CacheFailure())));
            },
          );
        },
      );
    },
  );
}
