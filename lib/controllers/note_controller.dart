import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/controllers/user_controller.dart';

class NoteController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveNote({
    required String title,
    required String content,
    required String backgroundColor,
  }) async {
    final user = UserController.user;
    if (user == null) {
      throw Exception('User not authenticated!');
    }

    final userId = user.uid;
    final notesCollection =
        _firestore.collection('Users').doc(userId).collection('Notes');

    await notesCollection.add({
      'title': title,
      'content': content,
      'date': FieldValue.serverTimestamp(),
      'backgroundColor': backgroundColor,
    });
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
      return {
        'id': doc.id,
        ...data,
      };
    }).toList();
  }
}
