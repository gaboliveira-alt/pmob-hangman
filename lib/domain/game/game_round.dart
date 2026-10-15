import '../model/hangman_entry.dart';
import '../text/letter_normalizer.dart';
import 'game_rules.dart';

class GameRound {
  final HangmanEntry entry;
  final int maxMistakes;

  final Set<String> _guessedKeys = {};
  int _mistakes = 0;
  bool _hintUsed = false;
  GameStatus _status = GameStatus.playing;

  GameRound({required this.entry, this.maxMistakes = kMaxMistakes});

  int get mistakes => _mistakes;
  int get mistakesRemaining => maxMistakes - _mistakes;
  bool get isHintUsed => _hintUsed;
  bool get isFinished => _status != GameStatus.playing;
  bool get hasMoreHints => !_hintUsed && entry.hints.isNotEmpty;
  String get hintText => entry.hints.isEmpty ? '' : entry.hints.first;
  Set<String> get guessedKeys => Set<String>.unmodifiable(_guessedKeys);
  GameStatus get status => _status;

  bool isLetterUsed(String letter) {
    final key = normalizeLetters(letter);
    return key != null && _guessedKeys.contains(key);
  }

  bool isLetterRevealed(String letter) {
    final key = normalizeLetters(letter);
    return key != null &&
        _guessedKeys.contains(key) &&
        entry.answer.containsKey(key);
  }

  GuessResult guessLetter(String letter) {
    final key = normalizeLetters(letter);
    if (key == null) return GuessResult.invalid;
    if (isFinished) return GuessResult.finished;
    if (_guessedKeys.contains(key)) return GuessResult.alreadyGuessed;

    _guessedKeys.add(key);

    if (entry.answer.containsKey(key)) {
      if (entry.answer.isFullyRevealed(_guessedKeys)) {
        _status = GameStatus.won;
      }
      return GuessResult.correct;
    }

    _mistakes++;
    if (_mistakes >= maxMistakes) {
      _status = GameStatus.lost;
    }
    return GuessResult.wrong;
  }

  bool requestHint() {
    if (isFinished || _hintUsed || entry.hints.isEmpty) return false;
    _hintUsed = true;
    return true;
  }
}
