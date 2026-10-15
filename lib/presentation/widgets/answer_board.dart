import 'package:flutter/material.dart';

import '../../domain/model/answer.dart';
import '../../domain/model/answer_cell.dart';

const double _minCellSize = 22;
const double _maxCellSize = 44;
const double _cellGap = 4;

class AnswerBoard extends StatelessWidget {
  const AnswerBoard({
    super.key,
    required this.answer,
    required this.guessedKeys,
  });

  final Answer answer;
  final Set<String> guessedKeys;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : _maxCellSize * 12;

        return Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 24,
          runSpacing: 16,
          children: [
            for (final word in answer.words)
              _WordLayout(
                cells: word.cells,
                guessedKeys: guessedKeys,
                maxWidth: maxWidth,
              ),
          ],
        );
      },
    );
  }
}

class _WordLayout extends StatelessWidget {
  const _WordLayout({
    required this.cells,
    required this.guessedKeys,
    required this.maxWidth,
  });

  final List<AnswerCell> cells;
  final Set<String> guessedKeys;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final count = cells.length;
    final fitted = count == 0
        ? _maxCellSize
        : (maxWidth - _cellGap * count) / count;
    final cellSize = fitted.clamp(_minCellSize, _maxCellSize).toDouble();
    final needed = count * cellSize + _cellGap * count;

    if (needed <= maxWidth) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final cell in cells)
            _LetterSlot(cell: cell, revealed: _revealed(cell), size: cellSize),
        ],
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final cell in cells)
          _LetterSlot(cell: cell, revealed: _revealed(cell), size: cellSize),
      ],
    );
  }

  bool _revealed(AnswerCell cell) =>
      cell is LetterCell && guessedKeys.contains(cell.keyLetter);
}

class _LetterSlot extends StatelessWidget {
  const _LetterSlot({
    required this.cell,
    required this.revealed,
    this.size = 36,
  });

  final AnswerCell cell;
  final bool revealed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isLetter = cell is LetterCell;
    final showText = !isLetter || revealed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: size,
        height: size * 1.2,
        alignment: Alignment.center,
        decoration: isLetter
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    width: 2,
                  ),
                ),
              )
            : null,
        child: showText
            ? Text(
                cell.display,
                style: TextStyle(
                  fontSize: size * 0.6,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
    );
  }
}
