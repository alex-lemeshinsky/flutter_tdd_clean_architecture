import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_example/core/network/network_info.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group(
    "isConnected",
    () {
      test(
        "should forward the call to InternetConnectionChecker.hasConnection",
        () async {
          final tHasConnectionFuture = Future.value(true);

          when(() => mockInternetConnectionChecker.hasConnection)
              .thenAnswer((invocation) => tHasConnectionFuture);

          final result = networkInfo.isConnected;

          verify(() => mockInternetConnectionChecker.hasConnection);
          expect(result, tHasConnectionFuture);
        },
      );
    },
  );
}
