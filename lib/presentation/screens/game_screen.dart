import 'package:flutter/material.dart';

import '../../domain/game/game_round.dart';
import '../../domain/game/game_rules.dart';
import '../../domain/model/answer_category.dart';
import '../../domain/model/difficulty.dart';
import '../../game_scope.dart';
import '../l10n/labels.dart';
import '../state/game_controller.dart';
import '../widgets/alphabet_keyboard.dart';
import '../widgets/answer_board.dart';
import '../widgets/hangman_figure.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Future<void> _startAnotherRound(GameController controller) async {
    final StartRoundResult result = controller.startAnotherRound();
    if (result == StartRoundResult.exhausted && mounted) {
      await showExhaustedDialog(context, controller);
    }
  }

  Future<void> _handleBack(GameController controller) async {
    final GameRound? round = controller.currentRound;
    if (round == null || round.isFinished) {
      Navigator.of(context).maybePop();
      return;
    }
    final bool abandon = await _confirmAbandon(context);
    if (!abandon || !mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final GameController controller = GameScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Forca'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handleBack(controller),
        ),
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? _) {
          final GameRound? round = controller.currentRound;
          if (round == null) {
            return const Center(child: Text('Nenhuma rodada em andamento.'));
          }

          if (round.isFinished) {
            return _ResultView(
              round: round,
              onNewRound: () => _startAnotherRound(controller),
              onChangeSelection: () => Navigator.of(context).maybePop(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: <Widget>[
                _StatusBar(
                  round: round,
                  onHintRequested: () => _showHint(context, controller),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: HangmanFigure(mistakes: round.mistakes),
                ),
                const SizedBox(height: 12),
                AnswerBoard(
                  answer: round.entry.answer,
                  guessedKeys: round.guessedKeys,
                ),
                const SizedBox(height: 16),
                AlphabetKeyboard(
                  round: round,
                  onLetter: controller.guessLetter,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.round, required this.onHintRequested});

  final GameRound round;
  final VoidCallback onHintRequested;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool canHint = round.hasMoreHints && !round.isFinished;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${round.entry.category.label} • ${round.entry.difficulty.label}',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Text('Erros: ${round.mistakes}/${round.maxMistakes}'),
                const Spacer(),
                TextButton.icon(
                  onPressed: canHint ? onHintRequested : null,
                  icon: const Icon(Icons.lightbulb_outline),
                  label: Text(round.isHintUsed ? 'Dica usada' : 'Ver dica'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: round.maxMistakes == 0
                  ? 0
                  : round.mistakes / round.maxMistakes,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.round,
    required this.onNewRound,
    required this.onChangeSelection,
  });

  final GameRound round;
  final VoidCallback onNewRound;
  final VoidCallback onChangeSelection;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool won = round.status == GameStatus.won;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Icon(
            won ? Icons.emoji_events : Icons.sentiment_dissatisfied,
            size: 64,
            color: won ? Colors.amber.shade700 : theme.colorScheme.error,
          ),
          const SizedBox(height: 8),
          Text(
            won ? 'Você venceu!' : 'Você perdeu!',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          SizedBox(height: 200, child: HangmanFigure(mistakes: round.mistakes)),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.spellcheck),
              title: const Text('Resposta'),
              subtitle: Text(round.entry.answer.text),
            ),
          ),
          const SizedBox(height: 8),
          Text('Erros: ${round.mistakes}/${round.maxMistakes}'),
          Text('Dica: ${round.isHintUsed ? 'utilizada' : 'não utilizada'}'),
          if (round.isHintUsed) ...<Widget>[
            const SizedBox(height: 4),
            Text(round.hintText, style: theme.textTheme.bodyMedium),
          ],
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              FilledButton(
                onPressed: onNewRound,
                child: const Text('Nova rodada'),
              ),
              OutlinedButton(
                onPressed: onChangeSelection,
                child: const Text('Trocar categoria/nível'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _showHint(BuildContext context, GameController controller) async {
  final GameRound? round = controller.currentRound;
  if (round == null) return;

  if (!round.isHintUsed) {
    controller.requestHint();
  }

  await showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Dica'),
      content: Text(
        round.hintText.isEmpty ? 'Sem dica disponível.' : round.hintText,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    ),
  );
}

Future<bool> _confirmAbandon(BuildContext context) async {
  final bool? abandon = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Abandonar rodada?'),
      content: const Text(
        'A rodada em andamento não será contabilizada nas estatísticas.',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Continuar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Abandonar'),
        ),
      ],
    ),
  );
  return abandon ?? false;
}

Future<bool> showExhaustedDialog(
  BuildContext context,
  GameController controller,
) async {
  final AnswerCategory? category = controller.selectedCategory;
  final Difficulty? difficulty = controller.selectedDifficulty;
  if (category == null || difficulty == null) return false;

  final bool? release = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Respostas esgotadas'),
      content: Text(
        'Todas as respostas de ${category.label}/${difficulty.label} '
        'já foram usadas nesta sessão.',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Liberar respostas deste conjunto'),
        ),
      ],
    ),
  );

  if (release != true) return false;

  controller.releaseUsedAnswers(category, difficulty);
  final StartRoundResult result = controller.startAnotherRound();
  return result == StartRoundResult.started;
}
