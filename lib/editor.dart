import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_bloc/bloc/note_bloc.dart';
import 'package:note_bloc/models/note.dart';
import 'package:uuid/uuid.dart';

enum EditStatus { unchanged, changed, deleted }

class EditorPage extends StatefulWidget {
  final Note? note;

  const EditorPage({Key? key, this.note}) : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  EditStatus status = EditStatus.unchanged;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note?.title ?? "";
    _contentController.text = widget.note?.content ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  void _handleChange(_) {
    setState(() => status = EditStatus.changed);
  }

  Future<bool> _handleBack() async {
    if (status == EditStatus.deleted || status == EditStatus.unchanged) {
      return true;
    }

    //Form validation
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    final Note noteToSave;
    //New note
    if (widget.note == null) {
      final id = const Uuid().v1();
      noteToSave = Note(
        id: id,
        title: _titleController.text,
        content: _contentController.text,
        updatedAt: DateTime.now(),
      );
    }
    //Update note
    else {
      noteToSave = widget.note!.copyWith(
        title: _titleController.text,
        content: _contentController.text,
        updatedAt: DateTime.now(),
      );
    }
    context.read<NoteBloc>().add(SaveNote(noteToSave));
    return true;
  }

  void _handleDelete() {
    context.read<NoteBloc>().add(DeleteNote(widget.note!));
    setState(() => status = EditStatus.deleted);
    Navigator.of(context).pop();
  }

  //Title & content validator
  String? _validator(String? text) {
    if (text == null || text.isEmpty) {
      return "Must not be empty";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBack,
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.note == null ? "New Note" : "Edit Note"),
            actions: widget.note == null
                ? null
                : [
                    IconButton(
                      onPressed: _handleDelete,
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
                    )
                  ],
          ),
          body: BlocBuilder<NoteBloc, NoteState>(
            builder: (context, state) {
              return Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Title",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    controller: _titleController,
                    enabled: state is! NoteLoading,
                    onChanged: _handleChange,
                    validator: _validator,
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Content",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      controller: _contentController,
                      enabled: state is! NoteLoading,
                      onChanged: _handleChange,
                      validator: _validator,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
