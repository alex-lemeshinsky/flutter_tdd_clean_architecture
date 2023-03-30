import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_example/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:tdd_example/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:tdd_example/features/number_trivia/presentation/widgets/trivia_display.dart';

class NumberTriviaPage extends StatelessWidget {
  NumberTriviaPage({super.key});

  final numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Number Trivia")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (BuildContext context, NumberTriviaState state) {
                    if (state is Empty) {
                      return const MessageDisplay(message: "Start searching");
                    } else if (state is Error) {
                      return MessageDisplay(message: state.message);
                    } else if (state is Loading) {
                      return const CircularProgressIndicator();
                    } else if (state is Loaded) {
                      return TriviaDisplay(numberTrivia: state.trivia);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Input a number",
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (value) => dispatchConcrete(context),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => dispatchConcrete(context),
                    child: const Text("Search"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => dispatchRandom(context),
                    child: const Text("Get random trivia"),
                  ),
                ),
              ],
            ),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  void dispatchConcrete(BuildContext context) {
    BlocProvider.of<NumberTriviaBloc>(context, listen: false).add(
      GetTriviaForConcreteNumber(numberController.text),
    );
    numberController.clear();
  }

  void dispatchRandom(BuildContext context) {
    BlocProvider.of<NumberTriviaBloc>(context, listen: false).add(
      const GetTriviaForRandomNumber(),
    );
    numberController.clear();
  }
}
