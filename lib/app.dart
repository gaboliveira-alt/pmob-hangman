import 'package:flutter/material.dart';

import 'game_scope.dart';
import 'presentation/screens/setup_screen.dart';
import 'presentation/state/game_controller.dart';

class HangmanApp extends StatefulWidget {
  const HangmanApp({super.key});

  @override
  State<HangmanApp> createState() => _HangmanAppState();
}

class _HangmanAppState extends State<HangmanApp> {
  final GameController _controller = GameController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameScope(
      controller: _controller,
      child: MaterialApp(
        title: 'Jogo da Forca',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const SetupScreen(),
      ),
    );
  }
}
