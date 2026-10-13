import 'answer.dart';
import 'answer_category.dart';
import 'difficulty.dart';

class HangmanEntry {
  final Answer answer;
  final AnswerCategory category;
  final Difficulty difficulty;
  final List<String> hints;

  const HangmanEntry({
    required this.answer,
    required this.category,
    required this.difficulty,
    required this.hints,
  });

  factory HangmanEntry.fromJson(Map<String, dynamic> json) {
    final Object? rawAnswer = json['answer'];
    if (rawAnswer is! String || rawAnswer.trim().isEmpty) {
      throw ArgumentError('campo "answer" ausente ou inválido');
    }

    final Object? rawCategory = json['category'];
    if (rawCategory is! String) {
      throw ArgumentError('campo "category" ausente ou inválido');
    }

    final Object? rawDifficulty = json['difficulty'];
    if (rawDifficulty is! String) {
      throw ArgumentError('campo "difficulty" ausente ou inválido');
    }

    final Object? rawHints = json['hints'];
    if (rawHints is! List) {
      throw ArgumentError('campo "difficulty" ausente ou inválido');
    }

    final List<String> hints = [];
    for (final Object? hint in rawHints) {
      if (hint is! String) {
        throw ArgumentError('dica inválida em "$rawAnswer"');
      }
      hints.add(hint);
    }

    return HangmanEntry(
      answer: Answer.parse(rawAnswer),
      category: answerCategoryFromName(rawCategory),
      difficulty: difficultyFromName(rawDifficulty),
      hints: List<String>.unmodifiable(hints),
    );
  }

  String get usedKey => '${category.name}:${difficulty.name}:${answer.text}';
}