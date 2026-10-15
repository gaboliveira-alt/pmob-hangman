import 'answer_cell.dart';

class AnswerWord {
  final List<AnswerCell> cells;

  const AnswerWord(this.cells);

  Set<String> get letterKeys => <String>{
    for (final cell in cells)
      if (cell is LetterCell) cell.keyLetter,
  };
}
