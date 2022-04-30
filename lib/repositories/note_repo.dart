import 'package:note_bloc/models/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteRepository {
  Future<List<Note>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList("notes") ?? [])
        .map((e) => Note.fromJson(e))
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<List<Note>> delete(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getAll();
    notes.removeWhere((e) => e.id == note.id);
    prefs.setStringList('notes', notes.map((e) => e.toJson()).toList());
    return notes;
  }

  Future<List<Note>> save(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getAll();
    final index = notes.indexWhere((e) => e.id == note.id);
    if (index != -1) {
      notes[index] = note;
    } else {
      notes.add(note);
    }
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    prefs.setStringList('notes', notes.map((e) => e.toJson()).toList());
    return notes;
  }
}
