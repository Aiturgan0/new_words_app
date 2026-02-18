import 'package:flutter/material.dart';

import 'package:new_words/l10n/app_localizations.dart';

class FolderMenu {
  static void show({
    required BuildContext context,
    required String title,
    required VoidCallback onAddTap,
    required VoidCallback onListTap,
    required VoidCallback onGameTap,
    required VoidCallback onFavTap,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _menuItem(
              Icons.add_circle_outline_rounded,
              AppLocalizations.of(context)!.add_words,
              Colors.orangeAccent,
              onAddTap,
            ),
            const SizedBox(height: 12),
            _menuItem(
              Icons.list_alt_rounded,
              AppLocalizations.of(context)!.word_list,
              Colors.blue,
              onListTap,
            ),
            const SizedBox(height: 12),
            _menuItem(
              Icons.play_circle_fill_rounded,
              AppLocalizations.of(context)!.practice,
              Colors.green,
              onGameTap,
            ),
            const SizedBox(height: 12),
            _menuItem(
              Icons.star_rounded,
              AppLocalizations.of(context)!.favorites,
              Colors.amber,
              onFavTap,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _menuItem(
    IconData icon,
    String text,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 15),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
