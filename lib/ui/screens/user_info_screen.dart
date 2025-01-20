import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/controllers/user_controller.dart';
import 'package:notes_app/ui/screens/login_screen.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 86,
        backgroundColor: Colors.transparent,
        titleSpacing: 25,
        title: Text(
          "Account",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                future: Future.value(FirebaseAuth.instance.currentUser),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final currentUser = snapshot.data!;
                    return Column(
                      children: [
                        CircleAvatar(
                          foregroundImage:
                              NetworkImage(currentUser.photoURL ?? ''),
                          radius: 48,
                        ),
                        Text(
                          currentUser.displayName!,
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white),
                        ),
                        Text(
                          currentUser.email!,
                          style: GoogleFonts.nunito(color: Colors.white),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.error);
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(height: 24),
              FilledButton.tonalIcon(
                onPressed: () async {
                  await UserController.signOut();

                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.logout_rounded),
                label: Text(
                  "Sign Out",
                  style: GoogleFonts.nunito(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
