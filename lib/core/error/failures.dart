import 'package:equatable/equatable.dart';
import 'package:tdd_example/const.dart';

abstract class Failure extends Equatable {
  final List properties;

  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object?> get props => [properties];

  @override
  String toString() {
    switch (runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return "Unexpected error";
    }
  }
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
