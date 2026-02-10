import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../widgets/folder_menu.dart';
import 'word_list.dart';
import 'game_screen.dart';
import 'add_word_screen.dart';

import 'package:new_words_app/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DbService _db = DbService();
  late List myDays;
  final TextEditingController _folderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myDays = _db.loadDays();
  }

  // 1. ПАПКАНЫН АТЫН ӨЗГӨРТҮҮ
  void _editFolderTitle(int index) {
    TextEditingController editController = TextEditingController(
      text: myDays[index]['title'],
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
                setState(() {
                  myDays[index]['title'] = editController.text;
                  _db.saveDays(myDays); // Базага сактоо
                });
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  // 2. ПАПКАНЫ БИРОТОЛО ӨЧҮРҮҮ
  void _deleteFolder(int index) {
    setState(() {
      myDays.removeAt(index); // Тизмеден өчүрүү
      _db.saveDays(myDays); // Базадан биротоло өчүрүү (жаңы тизмени сактоо)
    });
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
                setState(() {
                  myDays.add({'title': _folderController.text, 'words': []});
                  _db.saveDays(myDays);
                  _folderController.clear();
                });
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.add),
          ),
        ],
      ),
    );
  }

  void _showCenterMenu(int index) {
    FolderMenu.show(
      context: context,
      title: myDays[index]['title'],
      onAddTap: () async {
        Navigator.pop(context);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddWordScreen(dayIndex: index),
          ),
        );
        setState(() {
          myDays = _db.loadDays();
        });
      },
      onListTap: () async {
        Navigator.pop(context);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WordListScreen(dayIndex: index),
          ),
        );
        setState(() {
          myDays = _db.loadDays();
        });
      },
      onGameTap: () async {
        Navigator.pop(context);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(
              words: myDays[index]['words'],
              dayIndex: index,
              isFavMode: false,
            ),
          ),
        );
        setState(() {
          myDays = _db.loadDays();
        });
      },
      onFavTap: () async {
        Navigator.pop(context);
        List favs = (myDays[index]['words'] as List)
            .where((w) => w['isFav'] == true)
            .toList();

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                GameScreen(words: favs, dayIndex: index, isFavMode: true),
          ),
        );
        setState(() {
          myDays = _db.loadDays();
        });
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
      body: myDays.isEmpty
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
                        onPressed: () => _editFolderTitle(index),
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
                  onTap: () => _showCenterMenu(index),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewFolder,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, size: 35, color: Colors.white),
      ),
    );
  }
}
