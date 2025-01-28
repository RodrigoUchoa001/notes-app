import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/controllers/note_controller.dart';
import 'package:notes_app/ui/providers/note_background_color_provider.dart';
import 'package:notes_app/ui/screens/edit_note_screen.dart';
import 'package:notes_app/ui/widgets/app_bar_button.dart';
import 'package:notes_app/ui/widgets/home_screen/note_card.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final searchController = TextEditingController();

  List<NoteData> filteredNotesList = [];
  List<NoteData> notesList = [];

  @override
  void initState() {
    super.initState();

    _fetchNotes();
    searchController.addListener(_filterNotes);
  }

  Future<void> _fetchNotes() async {
    final fetchedNotes = await NoteController().getNotes();
    setState(() {
      notesList = fetchedNotes;
      filteredNotesList = fetchedNotes;
    });
  }

  void _filterNotes() {
    List<NoteData> tempList = notesList;

    if (searchController.text.isNotEmpty) {
      tempList = tempList
          .where((note) => note.title
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredNotesList = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252525),
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
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'Type to search...'),
              maxLines: null,
              controller: searchController,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 23,
              ),
            ),
            FutureBuilder(
              future: NoteController().getNotes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("ERRO: ${snapshot.error.toString()}"),
                  );
                } else if (!snapshot.hasData || filteredNotesList.isEmpty) {
                  return Center(
                    child: const Text("NENHUMA NOTA"),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: WaterfallFlow.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Número de colunas
                      crossAxisSpacing: 12, // Espaçamento horizontal
                      mainAxisSpacing: 12, // Espaçamento vertical
                    ),
                    itemCount: filteredNotesList.length,
                    itemBuilder: (context, index) {
                      final data = filteredNotesList[index];

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
                        child: NoteCard(
                          noteId: data.noteId,
                          title: data.title,
                          content: data.content,
                          color: data.color,
                          date: data.dateToString(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
