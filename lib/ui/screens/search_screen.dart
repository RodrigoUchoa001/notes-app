import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/controllers/note_controller.dart';
import 'package:notes_app/ui/widgets/app_bar_button.dart';
import 'package:notes_app/ui/widgets/home_screen/notes_list.dart';
import 'package:notes_app/ui/widgets/home_screen/shimmer_note_list.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {}); // Trigger rebuild when search text changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!;
          return _buildSearchContent(context, user);
        } else {
          return const Center(
              child: CircularProgressIndicator()); // Or login prompt
        }
      },
    );
  }

  Widget _buildSearchContent(BuildContext context, User user) {
    final _notesStream = NoteController().getStreamNotes(user.uid);

    return Scaffold(
      backgroundColor: const Color(0xFF252525),
      appBar: AppBar(
        backgroundColor: Color(0xFF252525),
        automaticallyImplyLeading: false,
        toolbarHeight: 86,
        actions: [
          const SizedBox(width: 24),
          AppBarButton(
            function: () => Navigator.pop(context),
            icon: FontAwesomeIcons.chevronLeft,
          ),
          Expanded(child: Container()),
          const SizedBox(width: 24),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          // Use Column instead of ListView
          children: [
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Type to search...',
                prefixIcon: Hero(
                  tag: 'search',
                  child: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.white.withAlpha(100),
                    size: 24,
                  ),
                ),
              ),
              maxLines: null,
              controller: searchController,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 23,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              // Use Expanded to fill remaining space
              child: StreamBuilder<List<NoteData>>(
                key: ValueKey(user.uid), // Key based on user UID
                stream: _notesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ShimmerNoteList();
                  } else if (snapshot.hasError) {
                    return Center(child: Text("ERRO: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.xmark, size: 56),
                          const SizedBox(height: 8),
                          Text(
                            "No notes to show!",
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final notes = snapshot.data!;
                  final filteredNotes = notes
                      .where((note) => note.title
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase()))
                      .toList();

                  if (filteredNotes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.xmark, size: 56),
                          const SizedBox(height: 8),
                          Text(
                            "No notes to show!",
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return NotesList(
                    notes: filteredNotes,
                    onNoteUpdated: () {
                      // No need to reload all notes
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
