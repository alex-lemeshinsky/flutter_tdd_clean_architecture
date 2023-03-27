import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_example/const.dart';
import 'package:tdd_example/core/error/exceptions.dart';
import 'package:tdd_example/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_example/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group(
    "getLastNumberTrivia",
    () {
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(jsonDecode(fixture("trivia_cached.json")));

      test(
        "should return NumberTrivia from SharedPreferences when there is one in the cache",
        () async {
          when(
            () => mockSharedPreferences
                .getString(cachedNumberTriviaSharedPreferencesKey),
          ).thenReturn(fixture("trivia_cached.json"));

          final result = await dataSource.getLastNumberTrivia();

          verify(() => mockSharedPreferences
              .getString(cachedNumberTriviaSharedPreferencesKey));
          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        "should throw a CacheExeption when there is not a cached value",
        () {
          when(() => mockSharedPreferences.getString(
              cachedNumberTriviaSharedPreferencesKey)).thenReturn(null);

          final call = dataSource.getLastNumberTrivia;

          expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
        },
      );
    },
  );

  group(
    "cacheNumberTrivia",
    () {
      const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "text");

      test(
        "should call SharedPreferences to cache the data",
        () {
          final expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());

          when(() => mockSharedPreferences.setString(
                cachedNumberTriviaSharedPreferencesKey,
                expectedJsonString,
              )).thenAnswer((invocation) async => true);

          dataSource.cacheNumberTrivia(tNumberTriviaModel);

          verify(
            () => mockSharedPreferences.setString(
              cachedNumberTriviaSharedPreferencesKey,
              expectedJsonString,
            ),
          );
        },
      );
    },
  );
}
