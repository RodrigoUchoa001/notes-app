import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/ui/screens/edit_note_screen.dart';
import 'package:notes_app/ui/screens/user_info_screen.dart';
import 'package:notes_app/ui/widgets/app_bar_button.dart';
import 'package:notes_app/ui/widgets/home_screen/notes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 86,
        backgroundColor: Colors.transparent,
        titleSpacing: 25,
        title: Text(
          "Notes",
          style: GoogleFonts.nunito(
            fontSize: 43,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          AppBarButton(
            function: () {},
            icon: Icons.search,
          ),
          const SizedBox(width: 12),
          FutureBuilder(
            future: Future.value(FirebaseAuth.instance.currentUser),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final currentUser = snapshot.data!;
                return IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserInfoScreen(),
                      ),
                    );
                  },
                  icon: CircleAvatar(
                    foregroundImage: NetworkImage(currentUser.photoURL ?? ''),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Icon(Icons.error);
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: Notes(),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditNoteScreen(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                titleText: '',
                contentText: '',
                dateText: '',
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(72),
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: Color(0xFF252525),
            borderRadius: BorderRadius.circular(72),
            boxShadow: [
              BoxShadow(
                color: Color(0x40000000),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
              BoxShadow(
                color: Color(0x40000000),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(-5, 0),
              ),
            ],
          ),
          child: Center(
            child: Icon(Icons.add, size: 48),
          ),
        ),
      ),
    );
  }
}
