import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/controllers/user_controller.dart';
import 'package:notes_app/ui/providers/is_loggin_in_provider.dart';
import 'package:notes_app/ui/screens/home_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogginIn = ref.watch(islogginInProvider);

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
                  ref.read(islogginInProvider.notifier).state = true;
                  await UserController.loginWithGoogle();

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                } catch (error) {
                  ref.read(islogginInProvider.notifier).state = false;
                  //
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Ocorreu um erro durante o login! Tente novamente."),
                    ),
                  );
                  UserController.signOut();
                }
              },
              icon: isLogginIn
                  ? const SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )
                  : Icon(Icons.login),
              label: const Text("Login with Google"),
            ),
          ],
        ),
      ),
    );
  }
}
