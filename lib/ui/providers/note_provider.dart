import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/firebase/controllers/note_controller.dart';

final userProvider =
    StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());

final notesStreamProvider = StreamProvider<List<NoteData>>((ref) {
  final userAsyncValue = ref.watch(userProvider);

  return userAsyncValue.when(
    data: (user) {
      if (user != null) {
        return NoteController().getStreamNotes(user.uid);
      } else {
        return Stream.empty();
      }
    },
    error: (error, _) {
      return throw Exception(error.toString());
    },
    loading: () {
      return Stream.empty();
    },
  );
});
