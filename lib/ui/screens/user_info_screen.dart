import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/controllers/user_controller.dart';
import 'package:notes_app/ui/screens/login_screen.dart';
import 'package:notes_app/ui/widgets/app_bar_button.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 86,
        backgroundColor: Colors.transparent,
        titleSpacing: 25,
        automaticallyImplyLeading: false,
        actions: [
          const SizedBox(width: 24),
          AppBarButton(
            function: () => Navigator.pop(context),
            icon: FontAwesomeIcons.chevronLeft,
          ),
          Expanded(child: Container()),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Hero(
                    tag: 'profilePic',
                    child: CircleAvatar(
                      foregroundImage:
                          NetworkImage(currentUser!.photoURL ?? ''),
                      radius: 48,
                    ),
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
                icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
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
