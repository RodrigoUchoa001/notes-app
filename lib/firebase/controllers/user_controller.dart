import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController {
  static User? user = FirebaseAuth.instance.currentUser;

  // TO NOT GET ERROR "ApiException: 10" HERE: when using "flutterfire configure"
  // set the name package as "com.example.(flutter_name_app)". Then set the SHA
  // codes.
  static Future<User?> loginWithGoogle() async {
    final googleAccount = await GoogleSignIn().signIn();
    if (googleAccount == null) return null;

    final googleAuth = await googleAccount.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );

    final user = userCredential.user;
    if (user == null) return null;

    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('Users').doc(user.uid);

    final userSnapshot = await userRef.get();
    if (!userSnapshot.exists) {
      await userRef.set({
        'email': user.email,
        'name': user.displayName ?? 'No Name',
        'photoURL': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'collabInvites': [],
      });
    }

    return user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  Stream<List<Invite>> getInvites(String userId) {
    final userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(userId);

    return userDocRef.snapshots().asyncMap((snapshot) async {
      if (!snapshot.exists) return [];

      final data = snapshot.data();
      if (data == null || !data.containsKey('collabInvites')) return [];

      final List invitesRaw = data['collabInvites'] as List;

      List<Invite> invites = [];

      for (var inviteData in invitesRaw) {
        String invitedById = inviteData['invitedBy'] ?? '';
        String noteId = inviteData['noteId'] ?? '';

        // Buscar nome do usuário que enviou o convite
        final invitedBySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(invitedById)
            .get();
        String invitedByName = invitedBySnapshot.exists
            ? (invitedBySnapshot.data()?['name'] ?? 'Usuário desconhecido')
            : 'Usuário desconhecido';

        // Buscar título da nota
        final noteSnapshot = await FirebaseFirestore.instance
            .collection('Notes')
            .doc(noteId)
            .get();
        String noteTitle = noteSnapshot.exists
            ? (noteSnapshot.data()?['title'] ?? 'Nota sem título')
            : 'Nota sem título';

        invites.add(Invite.fromMap(inviteData, invitedByName, noteTitle));
      }

      return invites;
    });
  }
}

class Invite {
  final String invitedBy;
  final String invitedByName;
  final String noteId;
  final String noteTitle;

  Invite({
    required this.invitedBy,
    required this.invitedByName,
    required this.noteId,
    required this.noteTitle,
  });

  factory Invite.fromMap(
      Map<String, dynamic> map, String invitedByName, String noteTitle) {
    return Invite(
      invitedBy: map['invitedBy'] ?? '',
      invitedByName: invitedByName,
      noteId: map['noteId'] ?? '',
      noteTitle: noteTitle,
    );
  }
}
