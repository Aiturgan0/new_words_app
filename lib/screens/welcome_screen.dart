import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_state.dart';
import '../blocs/language/language_bloc.dart';
import '../blocs/language/language_state.dart';
import 'package:new_words/l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Widget _langOption(BuildContext context, String title, String code, String currentCode) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 18)),
      onTap: () {
        context.read<LanguageBloc>().add(ChangeLanguage(code));
        Navigator.pop(context);
      },
      trailing: currentCode == code
          ? const Icon(Icons.check, color: Colors.blue)
          : null,
    );
  }

  void _showLanguageDialog(BuildContext context, String currentCode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.select_language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _langOption(context, '🇺🇸 English', 'en', currentCode),
            _langOption(context, '🇩🇪 Deutsch', 'de', currentCode),
            _langOption(context, '🇷🇺 Русский', 'ru', currentCode),
            _langOption(context, '🇰🇬 Кыргызча', 'ky', currentCode),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, langState) {
            bool isDark = themeState.themeMode == ThemeMode.dark;
            return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.language, color: Colors.white, size: 30),
              onPressed: () => _showLanguageDialog(context, langState.languageCode),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  context.read<ThemeBloc>().add(ToggleTheme());
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D1B2A) : null,
              gradient: isDark
                  ? null
                  : const LinearGradient(
                      colors: [Colors.indigo, Colors.blueAccent],
                    ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/NewWords.png'),
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.app_title,
                  style: TextStyle(
                    fontSize: langState.languageCode == 'ky'
                        ? 26
                        : 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.start,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
      },
    );
  }
}
