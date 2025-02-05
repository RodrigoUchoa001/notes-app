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
    } else {
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

  Stream<List<String>> getCollaboratorsNames(String currentUserId) {
    return FirebaseFirestore.instance
        .collection('Users')
        .where(FieldPath.documentId, whereIn: collaborators)
        .snapshots()
        .map((snapshot) {
      List<String> collaboratorsList =
          snapshot.docs.map((doc) => doc.get('name') as String).toList();

      final currentUserDoc = snapshot.docs.firstWhere(
        (doc) => doc.id == currentUserId,
      );

      final currentUserName = currentUserDoc.get('name') as String;
      collaboratorsList.remove(currentUserName);
      collaboratorsList.insert(0, currentUserName);

      return collaboratorsList;
    });
  }

  Future<void> removeCollaborator(String noteId, String collabName) async {
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    final notesCollection = FirebaseFirestore.instance.collection('Notes');

    final userQuery = await usersCollection
        .where('name', isEqualTo: collabName)
        .limit(1)
        .get();

    if (userQuery.docs.isEmpty) {
      throw Exception('User not found!');
    }

    final collaboratorId = userQuery.docs.first.id;

    await notesCollection.doc(noteId).update({
      'collaborators': FieldValue.arrayRemove([
        collaboratorId,
      ])
    });

    collaborators!.remove(collaboratorId);
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
