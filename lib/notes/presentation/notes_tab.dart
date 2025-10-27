import 'package:coding_test/notes/data/notes_repository.dart';
import 'package:coding_test/notes/logic/notes_cubit.dart';
import 'package:coding_test/notes/logic/notes_state.dart';
import 'package:coding_test/notes/presentation/widget/note_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_edit_note_page.dart';

class NotesTab extends StatelessWidget {
  const NotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotesCubit(NotesRepository())..loadNotes(),
      child: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          if (state.status == NotesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == NotesStatus.failure) {
            return Center(child: Text(state.errorMessage ?? 'Failed to load notes'));
          }

          final notes = state.notes;
          if (notes.isEmpty) {
            return const Center(child: Text('No notes yet. Tap + to add one.'));
          }

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditNotePage(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return NoteTile(note: note);
              },
            ),
          );
        },
      ),
    );
  }
}
