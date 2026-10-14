import 'answer_category.dart';
import 'difficulty.dart';
import 'hangman_entry.dart';

class HangmanCatalog {
  final List<HangmanEntry> entries;

  const HangmanCatalog(this.entries);

  List<AnswerCategory> get categories {
    final present = <AnswerCategory>{
      for (final entrie in entries) entrie.category,
    };
    return AnswerCategory.values.where(present.contains).toList(growable: false);
  }

  List<Difficulty> difficultiesFor(AnswerCategory category) {
    final present = <Difficulty>{
      for (final entrie in entries)
        if (entrie.category == category) entrie.difficulty,
    };
    return Difficulty.values.where(present.contains).toList(growable: false);
  }

  List<HangmanEntry> entriesFor(AnswerCategory category, Difficulty difficulty) =>
      entries
          .where((entrie) => entrie.category == category && entrie.difficulty == difficulty)
          .toList(growable: false);
}