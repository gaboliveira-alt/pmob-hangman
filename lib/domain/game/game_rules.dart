const int kMaxMistakes = 6;

const String kAlphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

enum GameStatus { playing, won, lost }

enum GuessResult { correct, wrong, alreadyGuessed, invalid, finished }

enum StartRoundResult { started, exhausted }
