import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_words/blocs/theme/theme_bloc.dart';
import 'package:new_words/blocs/theme/theme_state.dart';
import 'package:new_words/blocs/language/language_bloc.dart';
import 'package:new_words/blocs/language/language_state.dart';
import 'package:new_words/blocs/folders/folders_bloc.dart';
import 'package:new_words/blocs/folders/folders_state.dart';
import 'theme/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/welcome_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:new_words/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('flashcards_db');
  runApp(const NewWordsApp());
}

class NewWordsApp extends StatelessWidget {
  const NewWordsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(create: (context) => LanguageBloc()),
        BlocProvider(create: (context) => FoldersBloc()..add(LoadFolders())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, langState) {
              return MaterialApp(
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context)!.app_title,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'), // English
                  Locale('ky'), // Kyrgyz
                  Locale('ru'), // Russian
                  Locale('de'), // German
                ],
                locale: Locale(langState.languageCode),
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                home: WelcomeScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
