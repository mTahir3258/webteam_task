import 'package:coding_test/notes/logic/notes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditNotePage extends StatefulWidget {
  final Map<String, dynamic>? note;
  const AddEditNotePage({super.key, this.note});

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.note?['title'] ?? '');
    _contentCtrl = TextEditingController(text: widget.note?['content'] ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<NotesCubit>();
      if (widget.note == null) {
        await cubit.addNote(_titleCtrl.text, _contentCtrl.text);
      } else {
        await cubit.updateNote(widget.note!['id'], _titleCtrl.text, _contentCtrl.text);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v!.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentCtrl,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 5,
                validator: (v) => v!.isEmpty ? 'Content is required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveNote,
                child: Text(isEditing ? 'Update' : 'Add'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
