class LanguageModel {
  String code;
  String name;

  LanguageModel({required this.code, required this.name});

  static List<LanguageModel> languages = [
    LanguageModel(code: 'En', name: 'English'),
    LanguageModel(code: 'Ar', name: 'العربيه'),
    LanguageModel(code: 'Fr', name: 'Franch'),
  ];
}
