import 'package:equatable/equatable.dart';

// Events
abstract class FoldersEvent extends Equatable {
  const FoldersEvent();

  @override
  List<Object> get props => [];
}

class LoadFolders extends FoldersEvent {}

class AddFolder extends FoldersEvent {
  final String title;
  const AddFolder(this.title);

  @override
  List<Object> get props => [title];
}

class RenameFolder extends FoldersEvent {
  final int index;
  final String newTitle;

  const RenameFolder(this.index, this.newTitle);

  @override
  List<Object> get props => [index, newTitle];
}

class DeleteFolder extends FoldersEvent {
  final int index;
  const DeleteFolder(this.index);

  @override
  List<Object> get props => [index];
}

class AddWord extends FoldersEvent {
  final int folderIndex;
  final String wd;
  final String tr;

  const AddWord(this.folderIndex, this.wd, this.tr);

  @override
  List<Object> get props => [folderIndex, wd, tr];
}

class EditWord extends FoldersEvent {
  final int folderIndex;
  final int wordIndex;
  final String wd;
  final String tr;

  const EditWord(this.folderIndex, this.wordIndex, this.wd, this.tr);

  @override
  List<Object> get props => [folderIndex, wordIndex, wd, tr];
}

class DeleteWord extends FoldersEvent {
  final int folderIndex;
  final int wordIndex;

  const DeleteWord(this.folderIndex, this.wordIndex);

  @override
  List<Object> get props => [folderIndex, wordIndex];
}

class ToggleFavorite extends FoldersEvent {
  final int folderIndex;
  final int wordIndex;

  const ToggleFavorite(this.folderIndex, this.wordIndex);

  @override
  List<Object> get props => [folderIndex, wordIndex];
}

// States
class FoldersState extends Equatable {
  final List folders; // Format: [{'title': '...', 'words': [...]}]
  final int timestamp;

  const FoldersState({this.folders = const [], this.timestamp = 0});

  @override
  List<Object> get props => [folders, timestamp];
}
