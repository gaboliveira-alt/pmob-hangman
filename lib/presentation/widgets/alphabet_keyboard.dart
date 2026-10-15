import 'package:flutter/material.dart';

import '../../domain/game/game_round.dart';
import '../../domain/game/game_rules.dart';

class AlphabetKeyboard extends StatelessWidget {
  const AlphabetKeyboard({
    super.key,
    required this.round,
    required this.onLetter,
  });

  final GameRound round;
  final ValueChanged<String> onLetter;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final letter in kAlphabet.split(''))
          _Key(letter: letter, round: round, onLetter: onLetter),
      ],
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({
    required this.letter,
    required this.round,
    required this.onLetter,
  });

  final String letter;
  final GameRound round;
  final ValueChanged<String> onLetter;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final finished = round.isFinished;
    final used = round.isLetterUsed(letter);
    final correct = used && round.entry.answer.containsKey(letter);

    final Color background;
    final Color foreground;
    if (finished) {
      background = scheme.surfaceContainerHighest.withValues(alpha: 0.4);
      foreground = scheme.onSurface.withValues(alpha: 0.4);
    } else if (!used) {
      background = scheme.surfaceContainerHighest;
      foreground = scheme.onSurface;
    } else if (correct) {
      background = Colors.green.shade600;
      foreground = Colors.white;
    } else {
      background = scheme.errorContainer;
      foreground = scheme.onErrorContainer;
    }

    final radius = BorderRadius.circular(8);
    final onTap = (!finished && !used) ? () => onLetter(letter) : null;

    return SizedBox(
      width: 40,
      height: 44,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Material(
          color: background,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
