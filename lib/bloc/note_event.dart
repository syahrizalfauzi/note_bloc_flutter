part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class LoadNotes extends NoteEvent {}

class SaveNote extends NoteEvent {
  final Note note;

  const SaveNote(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteNote extends NoteEvent {
  final Note note;

  const DeleteNote(this.note);

  @override
  List<Object> get props => [note];
}
