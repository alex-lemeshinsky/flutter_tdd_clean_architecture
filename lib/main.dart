import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_example/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:tdd_example/injection_container.dart' as di;

import 'features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Number Trivia",
      home: BlocProvider(
        create: (BuildContext context) => sl<NumberTriviaBloc>(),
        child: NumberTriviaPage(),
      ),
    );
  }
}
