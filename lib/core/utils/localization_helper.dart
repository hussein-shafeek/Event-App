import 'package:evently/l10n/app_localizations.dart';

extension LocalizationHelper on AppLocalizations {
  String translate(String key) {
    switch (key) {
      case 'sport':
        return sport;
      case 'birthday':
        return birthday;
      case 'meeting':
        return meeting;
      case 'gaming':
        return gaming;
      case 'book':
        return book;
      case 'eating':
        return eating;
      case 'exhibition':
        return exhibition;
      case 'holiday':
        return holiday;
      case 'workshop':
        return workshop;
      default:
        return key;
    }
  }
}
