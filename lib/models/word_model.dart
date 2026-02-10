class DayFolder {
  String title;
  List<Map<String, String>> words;

  DayFolder({required this.title, required this.words});

  // Hive'га сактоо үчүн Map'ка айлантуу
  Map<String, dynamic> toMap() {
    return {'title': title, 'words': words};
  }

  // Кайра жүктөө үчүн
  factory DayFolder.fromMap(Map<dynamic, dynamic> map) {
    return DayFolder(
      title: map['title'],
      words: List<Map<String, String>>.from(
        map['words'].map((item) => Map<String, String>.from(item)),
      ),
    );
  }
}
