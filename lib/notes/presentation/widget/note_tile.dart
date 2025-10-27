import 'package:coding_test/notes/logic/notes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../add_edit_note_page.dart';

class NoteTile extends StatelessWidget {
  final Map<String, dynamic> note;
  const NoteTile({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(note['title'] ?? ''),
        subtitle: Text(
          note['content'] ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            final cubit = context.read<NotesCubit>();
            if (value == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditNotePage(note: note),
                ),
              );
            } else if (value == 'delete') {
              await cubit.deleteNote(note['id']);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}
