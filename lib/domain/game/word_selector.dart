import 'dart:math';

import '../model/answer_category.dart';
import '../model/difficulty.dart';
import '../model/hangman_catalog.dart';
import '../model/hangman_entry.dart';

class WordSelector {
  final Set<String> _usedAnswers = {};
  final Random _random = Random();

  Set<String> get usedAnswers => _usedAnswers;

  HangmanEntry? selectEntry(
    HangmanCatalog catalog,
    AnswerCategory category,
    Difficulty difficulty,
  ) {
    final pool = catalog
        .entriesFor(category, difficulty)
        .where((entry) => !_usedAnswers.contains(entry.usedKey))
        .toList();

    if (pool.isEmpty) return null;

    final entry = pool[_random.nextInt(pool.length)];
    _usedAnswers.add(entry.usedKey);
    return entry;
  }

  bool releaseUsed(AnswerCategory category, Difficulty difficulty) {
    final prefix = '${category.name}:${difficulty.name}:';
    final before = _usedAnswers.length;
    _usedAnswers.removeWhere((key) => key.startsWith(prefix));
    return _usedAnswers.length != before;
  }
}
