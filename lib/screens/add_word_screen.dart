import 'package:flutter/material.dart';
import '../services/db_service.dart';

import 'package:new_words_app/l10n/app_localizations.dart';

class AddWordScreen extends StatefulWidget {
  final int dayIndex;
  const AddWordScreen({super.key, required this.dayIndex});

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final DbService _db = DbService();
  final TextEditingController _wdController = TextEditingController();
  final TextEditingController _trController = TextEditingController();
  late List allData;
  List<Map<String, dynamic>> addedWordsSession = [];

  @override
  void initState() {
    super.initState();
    allData = _db.loadDays();
  }

  void _addWord() {
    if (_wdController.text.isNotEmpty && _trController.text.isNotEmpty) {
      setState(() {
        var newWord = {
          'wd': _wdController.text,
          'tr': _trController.text,
          'isFav': false,
        };
        allData[widget.dayIndex]['words'].insert(0, newWord);
        _db.saveDays(allData);

        // Add to session list for display
        addedWordsSession.insert(0, newWord);

        _wdController.clear();
        _trController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.add_words),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildInput(_wdController, AppLocalizations.of(context)!.word),
                const SizedBox(height: 15),
                _buildInput(
                  _trController,
                  AppLocalizations.of(context)!.translation,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _addWord,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.add,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: addedWordsSession.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.empty_word,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: addedWordsSession.length,
                    itemBuilder: (context, index) {
                      var word = addedWordsSession[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            word['wd'] ?? "",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(word['tr'] ?? ""),
                          leading: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
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

  Widget _buildInput(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey[100],
      ),
    );
  }
}
