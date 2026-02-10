import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('ky'),
    Locale('ru'),
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'My New Words'**
  String get app_title;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get start;

  /// No description provided for @my_folders.
  ///
  /// In en, this message translates to:
  /// **'My Folders'**
  String get my_folders;

  /// No description provided for @add_folder.
  ///
  /// In en, this message translates to:
  /// **'Add a folder'**
  String get add_folder;

  /// No description provided for @edit_folder.
  ///
  /// In en, this message translates to:
  /// **'Edit Folder Name'**
  String get edit_folder;

  /// No description provided for @enter_new_name.
  ///
  /// In en, this message translates to:
  /// **'Enter new name...'**
  String get enter_new_name;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @new_folder.
  ///
  /// In en, this message translates to:
  /// **'New Folder'**
  String get new_folder;

  /// No description provided for @enter_name.
  ///
  /// In en, this message translates to:
  /// **'Enter folder name...'**
  String get enter_name;

  /// No description provided for @word_list.
  ///
  /// In en, this message translates to:
  /// **'Word List'**
  String get word_list;

  /// No description provided for @add_words.
  ///
  /// In en, this message translates to:
  /// **'Add Words'**
  String get add_words;

  /// No description provided for @practice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @words.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get words;

  /// No description provided for @word.
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get word;

  /// No description provided for @translation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translation;

  /// No description provided for @empty_word.
  ///
  /// In en, this message translates to:
  /// **'Empty Word'**
  String get empty_word;

  /// No description provided for @no_translation.
  ///
  /// In en, this message translates to:
  /// **'No Translation'**
  String get no_translation;

  /// No description provided for @edit_word.
  ///
  /// In en, this message translates to:
  /// **'Edit Word'**
  String get edit_word;

  /// No description provided for @check_knowledge.
  ///
  /// In en, this message translates to:
  /// **'Do you know this word?'**
  String get check_knowledge;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @show_answer.
  ///
  /// In en, this message translates to:
  /// **'Show Answer'**
  String get show_answer;

  /// No description provided for @hide_answer.
  ///
  /// In en, this message translates to:
  /// **'Hide Answer'**
  String get hide_answer;

  /// No description provided for @back_home.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get back_home;

  /// No description provided for @well_done.
  ///
  /// In en, this message translates to:
  /// **'Well done! You learned all the words!'**
  String get well_done;

  /// No description provided for @folders_title.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get folders_title;

  /// No description provided for @delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete_confirm;

  /// No description provided for @delete_question.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this folder?'**
  String get delete_question;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'ky', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'ky':
      return AppLocalizationsKy();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
