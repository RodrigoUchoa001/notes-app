import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/firebase/controllers/user_controller.dart';
import 'package:notes_app/firebase/data/note_data.dart';

class NoteController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> saveNote({
    required String title,
    required String content,
    required Color backgroundColor,
    required String userId,
    String? noteId,
  }) async {
    final notesCollection = _firestore.collection('Notes');

    final actualDate = DateTime.now();

    final noteData = NoteData(
      title: title,
      content: content,
      date: DateTime(
        actualDate.year,
        actualDate.month,
        actualDate.day,
      ),
      backgroundColor: backgroundColor,
    );

    if (noteId != null) {
      await notesCollection.doc(noteId).update(
            noteData.toFirestore(userId),
          );
      return null;
    } else {
      final doc = await notesCollection.add(noteData.toFirestore(userId));
      return doc.id;
    }
  }

  Stream<List<NoteData>> getStreamNotes(String userId) {
    final notesCollection = _firestore.collection('Notes');

    return notesCollection
        .where('collaborators', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();

              return NoteData(
                noteId: doc.id,
                title: data['title'],
                content: data['content'],
                date: DateTime(data['date']['year'], data['date']['month'],
                    data['date']['day']),
                backgroundColor: mapToColor(data['backgroundColor']),
                collaborators: data['collaborators'],
                isOwner: userId == data['owner'] ? true : false,
              );
            }).toList());
  }

  Future<void> deleteNoteById(String noteId) async {
    final user = UserController.user;
    if (user == null) {
      throw Exception('User not authenticated!');
    }

    final notesCollection = _firestore.collection('Notes');

    await notesCollection.doc(noteId).delete();
  }

  Future<void> inviteCollaborator(
      String noteId, String myUserId, String collaboratorEmail) async {
    final firestore = FirebaseFirestore.instance;

    final usersCollection = firestore.collection('Users');

    final userQuery = await usersCollection
        .where('email', isEqualTo: collaboratorEmail)
        .limit(1)
        .get();

    if (userQuery.docs.isEmpty) {
      throw Exception('User not found!');
    }

    final collaboratorId = userQuery.docs.first.id;

    await usersCollection.doc(collaboratorId).update({
      'collabInvites': FieldValue.arrayUnion([
        {
          'noteId': noteId,
          'invitedBy': myUserId,
        }
      ])
    });
  }
}
