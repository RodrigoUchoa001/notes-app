import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteData {
  String? noteId;
  String title;
  String? content;
  DateTime date;
  Color backgroundColor;
  bool isOwner;
  List<dynamic>? collaborators;

  NoteData({
    this.noteId,
    required this.title,
    this.content,
    required this.date,
    this.backgroundColor = const Color(0xFF252525),
    this.isOwner = false,
    this.collaborators,
  });

  Map<String, dynamic> toFirestore(String userId) {
    final data = <String, dynamic>{};

    if (noteId != null) {
      data['id'] = title;

      List<String> collaboratorsList = [];
      collaboratorsList.add(userId);
      data['collaborators'] = collaboratorsList;
    }
    data['title'] = title;
    data['content'] = content;
    data['date'] = {};
    data['date']['year'] = date.year;
    data['date']['month'] = date.month;
    data['date']['day'] = date.day;
    data['backgroundColor'] = colorToMap(backgroundColor);
    data['owner'] = userId;

    return data;
  }

  String dateToString() {
    return DateFormat.yMMMd('en_US').format(date);
  }

  Future<List<dynamic>> getCollaboratorsNames() async {
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    final userNames = [];

    // Cria uma lista de documentos a serem buscados
    final userDocs = await Future.wait(
      collaborators!.map((userId) => usersCollection.doc(userId).get()),
    );

    // Popula a lista com os nomes dos usuários
    for (final doc in userDocs) {
      if (doc.exists) {
        userNames.add(doc.get('name') as String);
      }
    }
    return userNames;
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
