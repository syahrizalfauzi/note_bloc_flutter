import 'dart:convert';

import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String title;
  final String content;
  final DateTime updatedAt;
  final String id;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'id': id,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      id: map['id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  List<Object?> get props => [title, content, updatedAt, id];

  Note copyWith({
    String? title,
    String? content,
    DateTime? updatedAt,
    String? id,
  }) {
    return Note(
      title: title ?? this.title,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
    );
  }
}
