import 'package:hive_flutter/hive_flutter.dart';

class DbService {
  final _box = Hive.box('flashcards_db');

  // Маалыматты окуу
  List loadDays() {
    return _box.get("DAYS_DATA") ?? [];
  }

  // Маалыматты сактоо
  void saveDays(List days) {
    _box.put("DAYS_DATA", days);
  }
}
