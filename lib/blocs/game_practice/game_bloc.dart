import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/db_service.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final DbService _db = DbService();
  late List _allData;

  GameBloc() : super(const GameState()) {
    on<InitGame>((event, emit) {
      _allData = _db.loadDays();
      final words = List.from(event.words);
      final flipped = List.generate(words.length, (index) => false);
      emit(state.copyWith(
        currentWords: words,
        flippedStatus: flipped,
        isFavMode: event.isFavMode,
        isDeToRu: true,
      ));
    });

    on<ToggleDeToRu>((event, emit) {
      final flipped = List.generate(state.currentWords.length, (index) => false);
      emit(state.copyWith(
        isDeToRu: !state.isDeToRu,
        flippedStatus: flipped,
      ));
    });

    on<ToggleFlip>((event, emit) {
      final flipped = List<bool>.from(state.flippedStatus);
      flipped[event.index] = !flipped[event.index];
      emit(state.copyWith(flippedStatus: flipped));
    });

    on<ToggleFavoriteInGame>((event, emit) {
      final currentWords = List.from(state.currentWords);
      final flipped = List<bool>.from(state.flippedStatus);

      var word = currentWords[event.index];
      word['isFav'] = !(word['isFav'] ?? false);
      
      _db.saveDays(_allData);

      if (state.isFavMode && word['isFav'] == false) {
        currentWords.removeAt(event.index);
        flipped.removeAt(event.index);
      }

      emit(state.copyWith(
        currentWords: currentWords,
        flippedStatus: flipped,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    });
  }
}
