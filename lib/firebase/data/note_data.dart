import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteData {
  String noteId;
  String title;
  String content;
  DateTime date;
  Color color;
  bool isOwner;

  NoteData({
    required this.noteId,
    required this.title,
    required this.content,
    required this.date,
    required this.color,
    this.isOwner = false,
  });

  String dateToString() {
    return DateFormat.yMMMd('en_US').format(date);
  }
}
