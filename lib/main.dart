import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_bloc/bloc/note_bloc.dart';
import 'package:note_bloc/editor.dart';
import 'package:note_bloc/home.dart';
import 'package:note_bloc/models/note.dart';
import 'package:note_bloc/repositories/note_repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => NoteRepository(),
      child: BlocProvider(
        //Emit LoadNotes event on create (with cascade operator)
        create: (context) => NoteBloc(
          RepositoryProvider.of<NoteRepository>(context),
        )..add(LoadNotes()),
        child: MaterialApp(
          title: 'Note Bloc',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case "/":
                return MaterialPageRoute(builder: (_) => const HomePage());
              case "/note":
                return MaterialPageRoute(
                  builder: (_) => EditorPage(
                    note: settings.arguments as Note?,
                  ),
                );
              default:
                return MaterialPageRoute(builder: (_) => const HomePage());
            }
          },
        ),
      ),
    );
  }
}
