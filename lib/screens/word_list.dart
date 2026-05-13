import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/folders/folders_bloc.dart';
import '../blocs/folders/folders_state.dart';

import 'package:new_words/l10n/app_localizations.dart';

class WordListScreen extends StatefulWidget {
  final int dayIndex;
  const WordListScreen({super.key, required this.dayIndex});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _editWord(int index, Map word) {
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
              context.read<FoldersBloc>().add(
                EditWord(widget.dayIndex, index, gEdit.text, rEdit.text),
              );
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
    return BlocBuilder<FoldersBloc, FoldersState>(
      builder: (context, state) {
        if (state.folders.isEmpty || widget.dayIndex >= state.folders.length) {
          return const Scaffold(body: Center(child: Text("Folder not found")));
        }
        var folder = state.folders[widget.dayIndex];
        List words = folder['words'];
        
        return Scaffold(
          appBar: AppBar(
            title: Text(
              folder['title'] ?? AppLocalizations.of(context)!.words,
            ),
            elevation: 0,
          ),
          body: Column(
            children: [
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
                              onPressed: () => _editWord(index, word),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                context.read<FoldersBloc>().add(
                                  DeleteWord(widget.dayIndex, index),
                                );
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
      },
    );
  }
}
