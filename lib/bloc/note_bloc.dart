import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_bloc/models/note.dart';
import 'package:note_bloc/repositories/note_repo.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository repository;

  NoteBloc(this.repository) : super(NoteLoading()) {
    on<LoadNotes>((event, emit) async {
      final notes = await repository.getAll();
      emit(NoteLoaded(notes));
    });
    on<SaveNote>((event, emit) async {
      emit(NoteLoading());
      final notes = await repository.save(event.note);
      emit(NoteLoaded(notes));
    });
    on<DeleteNote>((event, emit) async {
      emit(NoteLoading());
      final notes = await repository.delete(event.note);
      emit(NoteLoaded(notes));
    });
  }
}
