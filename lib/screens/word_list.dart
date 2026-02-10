import 'package:flutter/material.dart';
import '../services/db_service.dart';

import 'package:new_words_app/l10n/app_localizations.dart';

class WordListScreen extends StatefulWidget {
  final int dayIndex;
  const WordListScreen({super.key, required this.dayIndex});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  final DbService _db = DbService();
  late List allData;

  @override
  void initState() {
    super.initState();
    allData = _db.loadDays();
  }

  void _editWord(int index) {
    var word = allData[widget.dayIndex]['words'][index];
    // Эски маалыматтар null болсо, бош текст чыгарат
    TextEditingController gEdit = TextEditingController(text: word['wd'] ?? "");
    TextEditingController rEdit = TextEditingController(text: word['tr'] ?? "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppLocalizations.of(context)!.edit_word),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: gEdit,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.word,
              ),
            ),
            TextField(
              controller: rEdit,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.translation,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                word['wd'] = gEdit.text;
                word['tr'] = rEdit.text;
                _db.saveDays(allData);
              });
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List words = allData[widget.dayIndex]['words'];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          allData[widget.dayIndex]['title'] ??
              AppLocalizations.of(context)!.words,
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // КОШУУ БӨЛҮМҮ

          // ТИЗМЕ БӨЛҮМҮ
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: words.length,
              itemBuilder: (context, index) {
                var word = words[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      word['wd'] ?? AppLocalizations.of(context)!.empty_word,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      word['tr'] ??
                          AppLocalizations.of(context)!.no_translation,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueGrey),
                          onPressed: () => _editWord(index),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            setState(() {
                              words.removeAt(index);
                              _db.saveDays(allData);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
