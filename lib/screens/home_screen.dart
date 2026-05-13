import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/folders/folders_bloc.dart';
import '../blocs/folders/folders_state.dart';
import '../widgets/folder_menu.dart';
import 'word_list.dart';
import 'game_screen.dart';
import 'add_word_screen.dart';

import 'package:new_words/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _folderController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // 1. ПАПКАНЫН АТЫН ӨЗГӨРТҮҮ
  void _editFolderTitle(int index, String currentTitle) {
    TextEditingController editController = TextEditingController(
      text: currentTitle,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppLocalizations.of(context)!.edit_folder),
        content: TextField(
          controller: editController,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enter_new_name,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (editController.text.isNotEmpty) {
                context.read<FoldersBloc>().add(RenameFolder(index, editController.text));
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void _deleteFolder(int index) {
    context.read<FoldersBloc>().add(DeleteFolder(index));
  }

  // 3. ЖАҢЫ ПАПКА КОШУУ
  void _addNewFolder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppLocalizations.of(context)!.new_folder),
        content: TextField(
          controller: _folderController,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enter_name,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (_folderController.text.isNotEmpty) {
                context.read<FoldersBloc>().add(AddFolder(_folderController.text));
                _folderController.clear();
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.add),
          ),
        ],
      ),
    );
  }

  void _showCenterMenu(int index, Map folder) {
    FolderMenu.show(
      context: context,
      title: folder['title'],
      onAddTap: () async {
        Navigator.pop(context);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddWordScreen(dayIndex: index),
          ),
        );
      },
      onListTap: () async {
        Navigator.pop(context);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WordListScreen(dayIndex: index),
          ),
        );
      },
      onGameTap: () async {
        Navigator.pop(context);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(
              words: folder['words'],
              dayIndex: index,
              isFavMode: false,
            ),
          ),
        );
      },
      onFavTap: () async {
        Navigator.pop(context);
        List favs = (folder['words'] as List)
            .where((w) => w['isFav'] == true)
            .toList();

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                GameScreen(words: favs, dayIndex: index, isFavMode: true),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.my_folders,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<FoldersBloc, FoldersState>(
        builder: (context, state) {
          final myDays = state.folders;
          return myDays.isEmpty
              ? Center(child: Text(AppLocalizations.of(context)!.add_folder))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: myDays.length,
                  itemBuilder: (context, index) => Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      leading: const Icon(
                        Icons.folder_rounded,
                        color: Colors.orange,
                        size: 45,
                      ),
                      title: Text(
                        myDays[index]['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${myDays[index]['words'].length} ${AppLocalizations.of(context)!.word.toLowerCase()}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ОҢДОО БАСКЫЧЫ
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.blueGrey,
                            ),
                            onPressed: () => _editFolderTitle(index, myDays[index]['title']),
                          ),
                          // БИРОТОЛО ӨЧҮРҮҮ БАСКЫЧЫ
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => _deleteFolder(index),
                          ),
                        ],
                      ),
                      onTap: () => _showCenterMenu(index, myDays[index]),
                    ),
                  ),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewFolder,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, size: 35, color: Colors.white),
      ),
    );
  }
}
