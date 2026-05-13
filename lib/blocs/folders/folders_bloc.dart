import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/db_service.dart';
import 'folders_state.dart';

class FoldersBloc extends Bloc<FoldersEvent, FoldersState> {
  final DbService _db = DbService();

  FoldersBloc() : super(const FoldersState()) {
    on<LoadFolders>((event, emit) {
      final folders = _db.loadDays();
      emit(FoldersState(folders: List.from(folders), timestamp: DateTime.now().millisecondsSinceEpoch));
    });

    on<AddFolder>((event, emit) {
      final currentFolders = List.from(state.folders);
      currentFolders.add({'title': event.title, 'words': []});
      _db.saveDays(currentFolders);
      emit(FoldersState(folders: currentFolders, timestamp: DateTime.now().millisecondsSinceEpoch));
    });

    on<RenameFolder>((event, emit) {
      final currentFolders = List.from(state.folders);
      currentFolders[event.index]['title'] = event.newTitle;
      _db.saveDays(currentFolders);
      emit(FoldersState(folders: currentFolders, timestamp: DateTime.now().millisecondsSinceEpoch));
    });

    on<DeleteFolder>((event, emit) {
      final currentFolders = List.from(state.folders);
      currentFolders.removeAt(event.index);
      _db.saveDays(currentFolders);
      emit(FoldersState(folders: currentFolders, timestamp: DateTime.now().millisecondsSinceEpoch));
    });

    on<AddWord>((event, emit) {
      final currentFolders = List.from(state.folders);
      var newWord = {
        'wd': event.wd,
        'tr': event.tr,
        'isFav': false,
      };
      currentFolders[event.folderIndex]['words'].insert(0, newWord);
      _db.saveDays(currentFolders);
      emit(FoldersState(folders: currentFolders, timestamp: DateTime.now().millisecondsSinceEpoch));
    });

    on<EditWord>((event, emit) {
      final currentFolders = List.from(state.folders);
      var word = currentFolders[event.folderIndex]['words'][event.wordIndex];
      word['wd'] = event.wd;
      word['tr'] = event.tr;
      _db.saveDays(currentFolders);
      emit(FoldersState(folders: currentFolders, timestamp: DateTime.now().millisecondsSinceEpoch));
    });

    on<DeleteWord>((event, emit) {
      final currentFolders = List.from(state.folders);
      currentFolders[event.folderIndex]['words'].removeAt(event.wordIndex);
      _db.saveDays(currentFolders);
      emit(FoldersState(folders: currentFolders, timestamp: DateTime.now().millisecondsSinceEpoch));
    });

    on<ToggleFavorite>((event, emit) {
      final currentFolders = List.from(state.folders);
      var word = currentFolders[event.folderIndex]['words'][event.wordIndex];
      word['isFav'] = !(word['isFav'] ?? false);
      _db.saveDays(currentFolders);
      emit(FoldersState(folders: currentFolders, timestamp: DateTime.now().millisecondsSinceEpoch));
    });
  }
}
