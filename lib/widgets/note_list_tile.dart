import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:note_bloc/bloc/note_bloc.dart';
import 'package:note_bloc/models/note.dart';

class NoteListTile extends StatelessWidget {
  const NoteListTile({
    Key? key,
    required this.note,
  }) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //Editor page
      onTap: () => Navigator.of(context).pushNamed(
        '/note',
        arguments: note,
      ),
      //Delete dialog
      onLongPress: () async {
        final deleteResult = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
            content: Text('Delete "${note.title}"?'),
          ),
        );
        if (deleteResult == null || !deleteResult) return;
        context.read<NoteBloc>().add(DeleteNote(note));
      },
      title: Text(note.title),
      subtitle: Text(
        note.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        DateFormat('HH:mm\nMMM d').format(note.updatedAt),
        textAlign: TextAlign.center,
      ),
    );
  }
}
