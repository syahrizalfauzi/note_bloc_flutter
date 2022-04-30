import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_bloc/bloc/note_bloc.dart';
import 'package:note_bloc/widgets/note_list_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Notes")),
          floatingActionButton: state is NoteLoaded
              ? FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () => Navigator.of(context).pushNamed('/note'),
                )
              : null,
          body: Builder(
            builder: (_) {
              if (state is NoteLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is NoteLoaded) {
                if (state.notes.isEmpty) {
                  return const Center(
                    child: Text('No Notes'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async =>
                      context.read<NoteBloc>().add(LoadNotes()),
                  child: ListView.builder(
                    itemCount: state.notes.length,
                    itemBuilder: (_, index) {
                      return NoteListTile(note: state.notes[index]);
                    },
                  ),
                );
              }
              return const Text('Invalid state, should not happen');
            },
          ),
        );
      },
    );
  }
}
