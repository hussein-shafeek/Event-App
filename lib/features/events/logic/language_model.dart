class LanguageModel {
  String code;
  String name;

  LanguageModel({required this.code, required this.name});

  static List<LanguageModel> languages = [
    LanguageModel(code: 'en', name: 'English'),
    LanguageModel(code: 'ar', name: 'العربيه'),
    LanguageModel(code: 'fr', name: 'Franch'),
  ];
}
