final class AnswerCell {
  final String display;

  const AnswerCell(this.display);
}

final class LetterCell extends AnswerCell {
  final String keyLetter;

  const LetterCell(super.display, {required this.keyLetter});
}

final class SeparatorCell extends AnswerCell {
  const SeparatorCell(super.display);
}
