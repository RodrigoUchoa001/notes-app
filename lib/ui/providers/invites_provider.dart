import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/firebase/controllers/user_controller.dart';
import 'package:notes_app/ui/providers/note_provider.dart';

final invitesProvider = StreamProvider<List<Invite>>((ref) {
  final userAsyncValue = ref.watch(userProvider);

  return userAsyncValue.when(
    data: (user) {
      if (user != null) {
        return UserController().getInvites(user.uid);
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
