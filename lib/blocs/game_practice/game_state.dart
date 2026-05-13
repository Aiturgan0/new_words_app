import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class InitGame extends GameEvent {
  final List words;
  final bool isFavMode;

  const InitGame(this.words, this.isFavMode);

  @override
  List<Object> get props => [words, isFavMode];
}

class ToggleDeToRu extends GameEvent {}

class ToggleFlip extends GameEvent {
  final int index;

  const ToggleFlip(this.index);

  @override
  List<Object> get props => [index];
}

class ToggleFavoriteInGame extends GameEvent {
  final int index;

  const ToggleFavoriteInGame(this.index);

  @override
  List<Object> get props => [index];
}

class GameState extends Equatable {
  final List currentWords;
  final List<bool> flippedStatus;
  final bool isDeToRu;
  final bool isFavMode;
  final int timestamp;

  const GameState({
    this.currentWords = const [],
    this.flippedStatus = const [],
    this.isDeToRu = true,
    this.isFavMode = false,
    this.timestamp = 0,
  });

  int get favCount => currentWords.where((w) => w['isFav'] == true).length;

  GameState copyWith({
    List? currentWords,
    List<bool>? flippedStatus,
    bool? isDeToRu,
    bool? isFavMode,
    int? timestamp,
  }) {
    return GameState(
      currentWords: currentWords ?? this.currentWords,
      flippedStatus: flippedStatus ?? this.flippedStatus,
      isDeToRu: isDeToRu ?? this.isDeToRu,
      isFavMode: isFavMode ?? this.isFavMode,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object> get props => [currentWords, flippedStatus, isDeToRu, isFavMode, timestamp];
}
