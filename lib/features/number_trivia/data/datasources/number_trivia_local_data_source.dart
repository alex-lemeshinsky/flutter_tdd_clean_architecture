import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_example/const.dart';
import 'package:tdd_example/core/error/exceptions.dart';
import 'package:tdd_example/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    await sharedPreferences.setString(
      cachedNumberTriviaSharedPreferencesKey,
      jsonEncode(triviaToCache.toJson()),
    );
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final jsonString =
        sharedPreferences.getString(cachedNumberTriviaSharedPreferencesKey);

    if (jsonString == null) {
      throw CacheException();
    }

    return NumberTriviaModel.fromJson(jsonDecode(jsonString));
  }
}
