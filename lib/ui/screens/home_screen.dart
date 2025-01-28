import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/controllers/note_controller.dart';
import 'package:notes_app/ui/providers/note_background_color_provider.dart';
import 'package:notes_app/ui/screens/edit_note_screen.dart';
import 'package:notes_app/ui/screens/search_screen.dart';
import 'package:notes_app/ui/screens/user_info_screen.dart';
import 'package:notes_app/ui/widgets/app_bar_button.dart';
import 'package:notes_app/ui/widgets/home_screen/note_card.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
            function: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
            icon: FontAwesomeIcons.magnifyingGlass,
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
                return const FaIcon(FontAwesomeIcons.xmark);
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
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: FutureBuilder(
            future: NoteController().getNotes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("ERRO: ${snapshot.error.toString()}"),
                );
              } else if (snapshot.data!.isEmpty) {
                return Center(
                  child: const Text("NENHUMA NOTA"),
                );
              }
              return WaterfallFlow.builder(
                gridDelegate:
                    const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Número de colunas
                  crossAxisSpacing: 12, // Espaçamento horizontal
                  mainAxisSpacing: 12, // Espaçamento vertical
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data![index];

                  // wait for the screen to come back from EditNoteScreen to HomeScreen,
                  // then setState to reload the notes
                  return GestureDetector(
                    onTap: () async {
                      ref.read(noteBackgroundColorProvider.notifier).state =
                          data.color;

                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditNoteScreen(
                            noteId: data.noteId,
                            titleText: data.title,
                            contentText: data.content,
                            dateText: data.dateToString(),
                          ),
                        ),
                      );

                      setState(() {});
                    },
                    child: Hero(
                      tag: data.noteId,
                      child: NoteCard(
                        noteId: data.noteId,
                        title: data.title,
                        content: data.content,
                        color: data.color,
                        date: data.dateToString(),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          ref.read(noteBackgroundColorProvider.notifier).state =
              Color(0xFF252525);

          // wait for the screen to come back from EditNoteScreen to HomeScreen,
          // then setState to reload the notes
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditNoteScreen(
                titleText: '',
                contentText: '',
                dateText: '',
              ),
            ),
          );

          setState(() {});
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
            child: FaIcon(FontAwesomeIcons.plus, size: 32),
          ),
        ),
      ),
    );
  }
}
