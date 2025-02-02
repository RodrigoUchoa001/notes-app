import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteData {
  String? noteId;
  String title;
  String? content;
  DateTime date;
  Color backgroundColor;
  bool isOwner;

  NoteData({
    this.noteId,
    required this.title,
    this.content,
    required this.date,
    this.backgroundColor = const Color(0xFF252525),
    this.isOwner = false,
  });

  Map<String, dynamic> toFirestore(String userId) {
    final data = <String, dynamic>{};

    if (noteId != null) {
      data['id'] = title;
    }
    data['title'] = title;
    data['content'] = content;
    data['date'] = {};
    data['date']['year'] = date.year;
    data['date']['month'] = date.month;
    data['date']['day'] = date.day;
    data['backgroundColor'] = colorToMap(backgroundColor);
    data['owner'] = userId;

    List<String> collaboratorsList = [];
    collaboratorsList.add(userId);
    data['collaborators'] = collaboratorsList;
    return data;
  }

  String dateToString() {
    return DateFormat.yMMMd('en_US').format(date);
  }
}

// functions to convert color to its channels, to save on firestore
Map<String, double> colorToMap(Color color) {
  return {
    'alpha': color.a,
    'red': color.r,
    'green': color.g,
    'blue': color.b,
  };
}

Color mapToColor(Map<String, dynamic> map) {
  return Color.from(
    alpha: map['alpha'],
    red: map['red'],
    green: map['green'],
    blue: map['blue'],
  );
}
