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
      });
    }

    return user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
