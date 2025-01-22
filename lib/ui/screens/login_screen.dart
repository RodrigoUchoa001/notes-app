import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/controllers/user_controller.dart';
import 'package:notes_app/ui/providers/is_logging_in_provider.dart';
import 'package:notes_app/ui/screens/home_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggingIn = ref.watch(isloggingInProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Notes App",
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 43,
                fontWeight: FontWeight.w600,
              ),
            ),
            FilledButton.icon(
              onPressed: () async {
                try {
                  ref.read(isloggingInProvider.notifier).state = true;
                  await UserController.loginWithGoogle();

                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                  ref.read(isloggingInProvider.notifier).state = false;
                } catch (error) {
                  ref.read(isloggingInProvider.notifier).state = false;
                  //
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("A error occurred! ${error.toString()}"),
                    ),
                  );
                  UserController.signOut();
                }
              },
              icon: isLoggingIn
                  ? const SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )
                  : FaIcon(FontAwesomeIcons.arrowRightToBracket),
              label: const Text("Login with Google"),
            ),
          ],
        ),
      ),
    );
  }
}
