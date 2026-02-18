import 'package:flutter/material.dart';
import '../services/db_service.dart';

import 'package:new_words/l10n/app_localizations.dart';

class GameScreen extends StatefulWidget {
  final List words;
  final int dayIndex;
  final bool isFavMode; // Маанилүү сөздөр режимин аныктоо үчүн

  const GameScreen({
    super.key,
    required this.words,
    required this.dayIndex,
    this.isFavMode = false, // машыгуу режими
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final DbService _db = DbService();
  late List allData;
  late List currentWords;
  late List<bool> flippedStatus;

  bool isDeToRu = true;

  @override
  void initState() {
    super.initState();
    allData = _db.loadDays();
    currentWords = List.from(widget.words);
    flippedStatus = List.generate(currentWords.length, (index) => false);
  }

  int get favCount => currentWords.where((w) => w['isFav'] == true).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            setState(() {
              isDeToRu = !isDeToRu;
              flippedStatus = List.generate(
                currentWords.length,
                (index) => false,
              );
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    isDeToRu
                        ? AppLocalizations.of(context)!.word
                        : AppLocalizations.of(context)!.translation,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.sync_alt_rounded,
                  color: Colors.blueAccent,
                  size: 26,
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  child: Text(
                    isDeToRu
                        ? AppLocalizations.of(context)!.translation
                        : AppLocalizations.of(context)!.word,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Center(
              child: Text(
                "★ $favCount",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
        ],
      ),
      // ЭКРАНДЫН ОРТОСУНДАГЫ ЖАЗУУ ЛОГИКАСЫ
      body: currentWords.isEmpty
          ? Center(
              child: Text(
                widget.isFavMode
                    ? AppLocalizations.of(context)!.favorites
                    : AppLocalizations.of(context)!.empty_word,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: currentWords.length,
              itemBuilder: (context, index) {
                var word = currentWords[index];

                String frontText = isDeToRu
                    ? (word['wd'] ?? "")
                    : (word['tr'] ?? "");
                String backText = isDeToRu
                    ? (word['tr'] ?? "")
                    : (word['wd'] ?? "");

                return GestureDetector(
                  onTap: () => setState(
                    () => flippedStatus[index] = !flippedStatus[index],
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color:
                          ((isDeToRu && !flippedStatus[index]) ||
                              (!isDeToRu && flippedStatus[index]))
                          ? Colors.blueAccent
                          : const Color(0xFF009688),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 5,
                          right: 5,
                          child: IconButton(
                            icon: Icon(
                              word['isFav'] == true
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              setState(() {
                                word['isFav'] = !(word['isFav'] ?? false);
                                _db.saveDays(allData);
                                // Эгер маанилүү сөздөр режиминде болсо, жылдызча алынса карта өчөт
                                if (widget.isFavMode &&
                                    word['isFav'] == false) {
                                  currentWords.removeAt(index);
                                  flippedStatus.removeAt(index);
                                }
                              });
                            },
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              flippedStatus[index] ? backText : frontText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
