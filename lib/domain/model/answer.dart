import '../text/letter_normalizer.dart';
import 'answer_word.dart';
import 'answer_cell.dart';

class Answer {
  final String text;
  final List<AnswerWord> words;
  final Set<String> lettersKeys;

  const Answer(this.text, this.words, this.lettersKeys);


  factory Answer.parse(String text) {
    final List<AnswerWord> words = [];
    List<AnswerCell> currentCell = [];

    void closeWord() {
      if (currentCell.isNotEmpty) {
        words.add(AnswerWord(List<AnswerCell>.unmodifiable(currentCell)));
        currentCell = [];
      }
    }

    for (final int rune in text.runes) {
      final character = String.fromCharCode(rune);
      final String? keyCh = normalizeLetters(character);

      if (keyCh != null) {
        currentCell.add(LetterCell(character, keyLetter: keyCh));
      } else if (isWhiteSpace(character)) {
        closeWord();
      } else {
        currentCell.add(SeparatorCell(character));
      }
    }
    closeWord();

    final Set<String> keys = {};

    for (final word in words) {
      for (final key in word.letterKeys) {
        keys.add(key);
      }
    }

    return Answer(
      text,
      List<AnswerWord>.unmodifiable(words),
      Set<String>.unmodifiable(keys),
    );
  }


  Iterable<LetterCell> get letters =>
      words.expand((word) => word.cells.whereType<LetterCell>());

  bool containsKey(String key) => lettersKeys.contains(key);

  bool isFullyRevealed(Set<String> guessedKeys) =>
      lettersKeys.every(guessedKeys.contains);
}