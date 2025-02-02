import 'package:flutter/material.dart';
import 'package:notes_app/controllers/note_controller.dart';
import 'package:notes_app/ui/providers/edit_mode_provider.dart';
import 'package:notes_app/ui/screens/edit_note_screen.dart';
import 'package:notes_app/ui/widgets/home_screen/note_card.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/ui/providers/note_background_color_provider.dart';

class NotesList extends ConsumerStatefulWidget {
  final List<NoteData> notes;

  const NotesList({super.key, required this.notes});

  @override
  ConsumerState<NotesList> createState() => _NotesListState();
}

class _NotesListState extends ConsumerState<NotesList> {
  @override
  Widget build(BuildContext context) {
    return WaterfallFlow.builder(
      gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: widget.notes.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final data = widget.notes[index];

        return GestureDetector(
          onTap: () async {
            ref.read(noteBackgroundColorProvider.notifier).state = data.color;

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
          },
          child: Hero(
            tag: data.noteId,
            child: Material(
              color: Colors.transparent,
              child: NoteCard(
                isOwner: data.isOwner,
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
  }
}
