class SessionStatistics {
  int _totalRounds = 0;
  int _wins = 0;
  int _losses = 0;
  int _totalMistakes = 0;
  int _hintsUsed = 0;

  int get totalRounds => _totalRounds;
  int get wins => _wins;
  int get losses => _losses;
  int get totalMistakes => _totalMistakes;
  int get hintsUsed => _hintsUsed;

  double get winPercentage =>
      totalRounds == 0 ? 0 : _wins * 100 / totalRounds;
  double get lossPercentage =>
      totalRounds == 0 ? 0 : _losses * 100 / totalRounds;

  void registerConcludedRound({required bool won, required int mistakes}) {
    _totalRounds++;
    if (won) {
      _wins++;
    } else {
      _losses++;
    }
    _totalMistakes += mistakes;
  }

  void registerHintUsed() => _hintsUsed++;
}
