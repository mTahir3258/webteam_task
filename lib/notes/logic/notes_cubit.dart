import 'package:coding_test/notes/data/notes_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final NotesRepository _repository;

  NotesCubit(this._repository) : super(const NotesState());

  void loadNotes() {
    emit(state.copyWith(status: NotesStatus.loading));
    _repository.getNotes().listen(
      (notes) {
        emit(state.copyWith(status: NotesStatus.success, notes: notes));
      },
      onError: (e) {
        emit(state.copyWith(status: NotesStatus.failure, errorMessage: e.toString()));
      },
    );
  }

  Future<void> addNote(String title, String content) async {
    await _repository.addNote(title, content);
  }

  Future<void> updateNote(String id, String title, String content) async {
    await _repository.updateNote(id, title, content);
  }

  Future<void> deleteNote(String id) async {
    await _repository.deleteNote(id);
  }
}
