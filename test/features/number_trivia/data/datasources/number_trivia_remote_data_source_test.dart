import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_example/core/error/exceptions.dart';
import 'package:tdd_example/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_example/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  const tNumber = 1;
  final tNumberTriviaModel =
      NumberTriviaModel.fromJson(jsonDecode(fixture("trivia.json")));

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group(
    "getConcreteNumberTrivia",
    () {
      void setUpMockHttpClientSuccess() {
        when(
          () => mockHttpClient.get(
            Uri.parse("http://numbersapi.com/$tNumber"),
            headers: {"Content-Type": "application/json"},
          ),
        ).thenAnswer(
          (invocation) async => http.Response(fixture("trivia.json"), 200),
        );
      }

      void setUpMockHttpClientFailure() {
        when(
          () => mockHttpClient.get(
            Uri.parse("http://numbersapi.com/$tNumber"),
            headers: {"Content-Type": "application/json"},
          ),
        ).thenAnswer(
          (invocation) async => http.Response("Something went wrong", 404),
        );
      }

      test(
        "should a GET request on a URL with number being the endpoint and with application/json header",
        () {
          setUpMockHttpClientSuccess();

          dataSource.getConcreteNumberTrivia(tNumber);

          verify(
            () => mockHttpClient.get(
              Uri.parse("http://numbersapi.com/$tNumber"),
              headers: {"Content-Type": "application/json"},
            ),
          );
        },
      );

      test(
        "should return NumberTrivia when the response code is 200 (success)",
        () async {
          setUpMockHttpClientSuccess();

          final result = await dataSource.getConcreteNumberTrivia(tNumber);

          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        "should throw a ServerException when the response code is 404 or other",
        () async {
          setUpMockHttpClientFailure();

          final call = dataSource.getConcreteNumberTrivia;

          expect(
            () => call(tNumber),
            throwsA(const TypeMatcher<ServerException>()),
          );
        },
      );
    },
  );

  group(
    "getRandomNumberTrivia",
    () {
      void setUpMockHttpClientSuccess() {
        when(
          () => mockHttpClient.get(
            Uri.parse("http://numbersapi.com/random"),
            headers: {"Content-Type": "application/json"},
          ),
        ).thenAnswer(
          (invocation) async => http.Response(fixture("trivia.json"), 200),
        );
      }

      void setUpMockHttpClientFailure() {
        when(
          () => mockHttpClient.get(
            Uri.parse("http://numbersapi.com/random"),
            headers: {"Content-Type": "application/json"},
          ),
        ).thenAnswer(
          (invocation) async => http.Response("Something went wrong", 404),
        );
      }

      test(
        "should a GET request on a URL with number being the endpoint and with application/json header",
        () {
          setUpMockHttpClientSuccess();

          dataSource.getRandomNumberTrivia();

          verify(
            () => mockHttpClient.get(
              Uri.parse("http://numbersapi.com/random"),
              headers: {"Content-Type": "application/json"},
            ),
          );
        },
      );

      test(
        "should return NumberTrivia when the response code is 200 (success)",
        () async {
          setUpMockHttpClientSuccess();

          final result = await dataSource.getRandomNumberTrivia();

          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        "should throw a ServerException when the response code is 404 or other",
        () async {
          setUpMockHttpClientFailure();

          final call = dataSource.getRandomNumberTrivia;

          expect(
            () => call(),
            throwsA(const TypeMatcher<ServerException>()),
          );
        },
      );
    },
  );
}
