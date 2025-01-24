import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    final notesCollection =
        _firestore.collection('Users').doc(userId).collection('Notes');

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
    };

    if (noteId != null) {
      await notesCollection.doc(noteId).set(noteData);
      return null;
    } else {
      final doc = await notesCollection.add(noteData);
      return doc.id;
    }
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final user = UserController.user;
    if (user == null) {
      throw Exception('User not authenticated!');
    }

    final userId = user.uid;
    final notesCollection =
        _firestore.collection('Users').doc(userId).collection('Notes');

    final querySnapshot =
        await notesCollection.orderBy('date', descending: true).get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      final colorMap = data['backgroundColor'] as Map<String, dynamic>;
      final backgroundColor = mapToColor(colorMap);

      return {
        'id': doc.id,
        'title': data['title'],
        'content': data['content'],
        'date': data['date'],
        'backgroundColor': backgroundColor,
      };
    }).toList();
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
  return Color.fromARGB(
    map['alpha'] as int,
    map['red'] as int,
    map['green'] as int,
    map['blue'] as int,
  );
}
