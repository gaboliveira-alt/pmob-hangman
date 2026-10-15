const _diacritics = <String, String>{
  'Á': 'A',
  'À': 'A',
  'Â': 'A',
  'Ã': 'A',
  'Ä': 'A',
  'É': 'E',
  'È': 'E',
  'Ê': 'E',
  'Ë': 'E',
  'Í': 'I',
  'Ì': 'I',
  'Î': 'I',
  'Ï': 'I',
  'Ó': 'O',
  'Ò': 'O',
  'Ô': 'O',
  'Õ': 'O',
  'Ö': 'O',
  'Ú': 'U',
  'Ù': 'U',
  'Û': 'U',
  'Ü': 'U',
  'Ç': 'C',
};

bool isAlphaLetter(String character) {
  if (character.length != 1) return false;
  final intCode = character.codeUnitAt(0);
  return intCode >= 0x41 && intCode <= 0x5A;
}

bool isWhiteSpace(String character) {
  return character.isNotEmpty && character.trim().isEmpty;
}

String? normalizeLetters(String character) {
  final upperCh = character.toUpperCase();
  final base = _diacritics[upperCh] ?? upperCh;
  return isAlphaLetter(base) ? base : null;
}
