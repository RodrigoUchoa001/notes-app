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
  late Future<List<NoteData>> _notesFuture;

  List<NoteData> filteredNotesList = [];
  List<NoteData> notesList = [];

  @override
  void initState() {
    super.initState();

    _loadNotes();
    searchController.addListener(_filterNotes);
  }

  Future<void> _loadNotes() async {
    _notesFuture = NoteController().getNotes();
    final fetchedNotes = await _notesFuture;
    setState(() {
      notesList = fetchedNotes;
      filteredNotesList = _filterNotes();
    });
  }

  List<NoteData> _filterNotes() {
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

    return filteredNotesList;
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
        child: ListView(
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
            FutureBuilder(
              future: _notesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ShimmerNoteList();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("ERRO: ${snapshot.error.toString()}"),
                  );
                } else if (!snapshot.hasData || filteredNotesList.isEmpty) {
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
                  notes: filteredNotesList,
                  onNoteUpdated: () {
                    _loadNotes();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
