import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/controllers/user_controller.dart';

class NoteController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> saveNote({
    required String title,
    required String content,
    required Color backgroundColor,
    String? noteId,
  }) async {
    final user = UserController.user;
    if (user == null) {
      throw Exception('User not authenticated!');
    }

    final userId = user.uid;
    final notesCollection = _firestore.collection('Notes');

    final actualDate = DateTime.now();

    final noteData = {
      'title': title,
      'content': content,
      'date': {
        'day': actualDate.day,
        'month': actualDate.month,
        'year': actualDate.year,
      },
      'backgroundColor': colorToMap(backgroundColor),
      'collaborators': [
        userId,
      ]
    };

    if (noteId != null) {
      await notesCollection.doc(noteId).update({
        'title': title,
        'content': content,
        'date': {
          'day': actualDate.day,
          'month': actualDate.month,
          'year': actualDate.year,
        },
        'backgroundColor': colorToMap(backgroundColor),
      });
      return null;
    } else {
      final doc = await notesCollection.add(noteData);
      return doc.id;
    }
  }

  Future<List<NoteData>> getNotes() async {
    final user = UserController.user;
    if (user == null) {
      throw Exception('User not authenticated!');
    }

    final userId = user.uid;
    final notesCollection = _firestore.collection('Notes');

    final querySnapshot = await notesCollection
        .where('collaborators', arrayContains: userId)
        // .orderBy('date.year', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      final colorMap = data['backgroundColor'] as Map<String, dynamic>;
      final backgroundColor = mapToColor(colorMap);

      return NoteData(
        noteId: doc.id,
        title: data['title'],
        content: data['content'],
        date: DateTime(
          data['date']['year'],
          data['date']['month'],
          data['date']['day'],
        ),
        color: backgroundColor,
      );
    }).toList();
  }

  Future<void> deleteNoteById(String noteId) async {
    final user = UserController.user;
    if (user == null) {
      throw Exception('User not authenticated!');
    }

    final notesCollection = _firestore.collection('Notes');

    await notesCollection.doc(noteId).delete();
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

class NoteData {
  String noteId;
  String title;
  String content;
  DateTime date;
  Color color;

  NoteData({
    required this.noteId,
    required this.title,
    required this.content,
    required this.date,
    required this.color,
  });

  String dateToString() {
    return DateFormat.yMMMd('en_US').format(date);
  }
}
