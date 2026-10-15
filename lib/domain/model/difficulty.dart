enum Difficulty { easy, medium, hard }

Difficulty difficultyFromName(String value) => Difficulty.values.byName(value);
