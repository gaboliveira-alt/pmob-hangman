enum AnswerCategory { animals, humanBody, sports, technology }

AnswerCategory answerCategoryFromName(String value) =>
    AnswerCategory.values.byName(value);
