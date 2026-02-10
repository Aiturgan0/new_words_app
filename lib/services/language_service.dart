import 'package:flutter/material.dart';

class LanguageService {
  static final ValueNotifier<String> currentLanguage = ValueNotifier('en');

  static void changeLanguage(String languageCode) {
    currentLanguage.value = languageCode;
  }
}
