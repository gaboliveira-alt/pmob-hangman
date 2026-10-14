import 'package:flutter/widgets.dart';

import 'presentation/state/game_controller.dart';

class GameScope extends InheritedNotifier<GameController> {
  const GameScope({
    super.key,
    required GameController controller,
    required super.child,
  }) : super(notifier: controller);

  static GameController of(BuildContext context, {bool listen = false}) {
    final scope = listen
        ? context.dependOnInheritedWidgetOfExactType<GameScope>()
        : context.getInheritedWidgetOfExactType<GameScope>();
    return scope!.notifier!;
  }
}
