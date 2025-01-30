import 'package:flutter/material.dart';
import 'package:notes_app/controllers/note_controller.dart';
import 'package:notes_app/ui/providers/edit_mode_provider.dart';
import 'package:notes_app/ui/screens/edit_note_screen.dart';
import 'package:notes_app/ui/widgets/home_screen/note_card.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/ui/providers/note_background_color_provider.dart';

class NotesList extends ConsumerStatefulWidget {
  final Function() onNoteUpdated;

  const NotesList({super.key, required this.onNoteUpdated});

  @override
  ConsumerState<NotesList> createState() => _NotesListState();
}

class _NotesListState extends ConsumerState<NotesList> {
  late Future<List<NoteData>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() {
    setState(() {
      _notesFuture = NoteController().getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadNotes();
      },
      child: FutureBuilder<List<NoteData>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("ERRO: ${snapshot.error.toString()}"));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text("NENHUMA NOTA"));
          }

          final notes = snapshot.data!;

          return WaterfallFlow.builder(
            gridDelegate:
                const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final data = notes[index];

              return GestureDetector(
                onTap: () async {
                  ref.read(noteBackgroundColorProvider.notifier).state =
                      data.color;

                  ref.read(editModeProvider.notifier).state = false;

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

                  Future.delayed(const Duration(milliseconds: 350), () {
                    _loadNotes();
                    widget.onNoteUpdated();
                  });
                },
                child: Hero(
                  tag: data.noteId,
                  child: Material(
                    color: Colors.transparent,
                    child: NoteCard(
                      noteId: data.noteId,
                      title: data.title,
                      content: data.content,
                      color: data.color,
                      date: data.dateToString(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
