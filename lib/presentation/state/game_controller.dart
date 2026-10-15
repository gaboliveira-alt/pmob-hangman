import 'package:flutter/foundation.dart';

import '../../data/catalog_manager.dart';
import '../../domain/game/game_round.dart';
import '../../domain/game/game_rules.dart';
import '../../domain/game/word_selector.dart';
import '../../domain/model/answer_category.dart';
import '../../domain/model/difficulty.dart';
import '../../domain/model/session_statistics.dart';

export '../../data/catalog_manager.dart' show CatalogStatus;

class GameController extends ChangeNotifier {
  final CatalogManager _catalogManager;
  final WordSelector _wordSelector = WordSelector();

  AnswerCategory? _selectedCategory;
  Difficulty? _selectedDifficulty;

  GameRound? _round;
  bool _resultRegistered = false;
  final SessionStatistics _statistics = SessionStatistics();

  GameController([CatalogManager? catalogManager])
    : _catalogManager = catalogManager ?? CatalogManager();

  CatalogStatus get catalogStatus => _catalogManager.status;
  String? get errorMessage => _catalogManager.errorMessage;

  List<AnswerCategory> get categories => _catalogManager.categories;
  List<Difficulty> difficultiesFor(AnswerCategory category) =>
      _catalogManager.difficultiesFor(category);

  AnswerCategory? get selectedCategory => _selectedCategory;
  Difficulty? get selectedDifficulty => _selectedDifficulty;

  GameRound? get currentRound => _round;
  SessionStatistics get statistics => _statistics;
  Set<String> get usedAnswers => _wordSelector.usedAnswers;

  void loadCatalog() {
    _catalogManager.load();
    notifyListeners();
  }

  void selectCategory(AnswerCategory category) {
    _selectedCategory = category;
    if (_selectedDifficulty != null &&
        !difficultiesFor(category).contains(_selectedDifficulty)) {
      _selectedDifficulty = null;
    }
    notifyListeners();
  }

  void selectDifficulty(Difficulty difficulty) {
    _selectedDifficulty = difficulty;
    notifyListeners();
  }

  StartRoundResult startRound({
    required AnswerCategory category,
    required Difficulty difficulty,
  }) {
    _selectedCategory = category;
    _selectedDifficulty = difficulty;

    final catalog = _catalogManager.catalog;
    if (catalog == null) return StartRoundResult.exhausted;

    final entry = _wordSelector.selectEntry(catalog, category, difficulty);
    if (entry == null) return StartRoundResult.exhausted;

    _round = GameRound(entry: entry);
    _resultRegistered = false;
    notifyListeners();
    return StartRoundResult.started;
  }

  StartRoundResult startAnotherRound() {
    final category = _selectedCategory;
    final difficulty = _selectedDifficulty;
    if (category == null || difficulty == null) {
      return StartRoundResult.exhausted;
    }
    return startRound(category: category, difficulty: difficulty);
  }

  bool releaseUsedAnswers(AnswerCategory category, Difficulty difficulty) {
    final released = _wordSelector.releaseUsed(category, difficulty);
    if (released) notifyListeners();
    return released;
  }

  GuessResult guessLetter(String letter) {
    final round = _round;
    if (round == null) return GuessResult.finished;

    final result = round.guessLetter(letter);

    if (round.isFinished && !_resultRegistered) {
      _resultRegistered = true;
      _statistics.registerConcludedRound(
        won: round.status == GameStatus.won,
        mistakes: round.mistakes,
      );
    }

    notifyListeners();
    return result;
  }

  bool requestHint() {
    final round = _round;
    if (round == null) return false;

    final granted = round.requestHint();
    if (granted) {
      _statistics.registerHintUsed();
    }
    notifyListeners();
    return granted;
  }
}
