import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../theme/app_theme.dart';
import '../services/language_service.dart';
import 'package:new_words_app/l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.select_language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _langOption(context, '🇺🇸 English', 'en'),
            _langOption(context, '🇩🇪 Deutsch', 'de'),
            _langOption(context, '🇷🇺 Русский', 'ru'),
            _langOption(context, '🇰🇬 Кыргызча', 'ky'),
          ],
        ),
      ),
    );
  }

  Widget _langOption(BuildContext context, String title, String code) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 18)),
      onTap: () {
        LanguageService.currentLanguage.value = code;
        Navigator.pop(context);
      },
      trailing: LanguageService.currentLanguage.value == code
          ? const Icon(Icons.check, color: Colors.blue)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, mode, child) {
        bool isDark = mode == ThemeMode.dark;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.language, color: Colors.white, size: 30),
              onPressed: () => _showLanguageDialog(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  AppTheme.themeModeNotifier.value = isDark
                      ? ThemeMode.light
                      : ThemeMode.dark;
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
                const Icon(Icons.style, size: 100, color: Colors.white),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.app_title,
                  style: TextStyle(
                    fontSize: LanguageService.currentLanguage.value == 'ky'
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
  }
}
