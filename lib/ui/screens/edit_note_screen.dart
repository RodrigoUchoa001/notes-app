import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/controllers/note_controller.dart';
import 'package:notes_app/ui/providers/edit_mode_provider.dart';
import 'package:notes_app/ui/providers/note_background_color_provider.dart';
import 'package:notes_app/ui/providers/saving_state_provider.dart';
import 'package:notes_app/ui/widgets/app_bar_button.dart';
import 'package:notes_app/ui/widgets/edit_note_screen/background_color_selector.dart';
import 'package:notes_app/utils.dart';

class EditNoteScreen extends ConsumerStatefulWidget {
  const EditNoteScreen(
      {required this.titleText,
      required this.dateText,
      required this.contentText,
      this.noteId,
      super.key});
  final String titleText;
  final String dateText;
  final String contentText;
  final String? noteId;

  @override
  ConsumerState<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends ConsumerState<EditNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final dateController = TextEditingController();

  String? newNoteId;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.titleText;
    contentController.text = widget.contentText;

    newNoteId = widget.noteId;
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = ref.watch(editModeProvider);
    final backgroundColorFromProvider = ref.watch(noteBackgroundColorProvider);
    final isSaving = ref.watch(savingStateProvider);

    // function executed after the widget is builded. Used to enable the
    // editMode if is a new note (the textfields are empty)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // set in start as not editMode (DONT WORK!!!!!!!!)
      // ref.read(editModeProvider.notifier).state = false;

      // if (titleText.isEmpty && contentText.isEmpty) {
      //   ref.read(editModeProvider.notifier).state = true;
      // }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColorFromProvider,
        automaticallyImplyLeading: false,
        toolbarHeight: 86,
        actions: [
          const SizedBox(width: 24),
          AppBarButton(
            function: () => Navigator.pop(context),
            icon: FontAwesomeIcons.chevronLeft,
          ),
          Expanded(child: Container()),
          newNoteId != null
              ? AppBarButton(
                  function: () {
                    _deleteDialog(context);
                  },
                  icon: FontAwesomeIcons.trashCan,
                )
              : Container(),
          const SizedBox(width: 8),
          AppBarButton(
            isLoading: isSaving,
            function: () async {
              ref.read(editModeProvider.notifier).state = !isEditMode;

              // if clicked to save, savingState set to true
              if (isEditMode) {
                ref.read(savingStateProvider.notifier).state = true;
              }

              // if finished editing, save to firestore database...
              if (!ref.read(editModeProvider.notifier).state) {
                try {
                  final docId = await NoteController().saveNote(
                    title: titleController.text,
                    content: contentController.text,
                    backgroundColor: backgroundColorFromProvider,
                    noteId: newNoteId,
                  );

                  newNoteId ??= docId;

                  // To update the screen and show the delete button
                  // By saving, the line above set the note id on "newNoteId",
                  // turning it to not null, that makes the delete button appears
                  setState(() {});

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Note saved!"),
                    ),
                  );
                  ref.read(savingStateProvider.notifier).state = false;
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("A error occurred! ${e.toString()}"),
                    ),
                  );
                  ref.read(savingStateProvider.notifier).state = false;
                }
              }
            },
            icon: isEditMode
                ? FontAwesomeIcons.floppyDisk
                : FontAwesomeIcons.penToSquare,
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: Hero(
        tag: widget.noteId ?? 'newNote',
        child: Container(
          color: backgroundColorFromProvider,
          child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              color: Colors.transparent,
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    enabled: isEditMode ? true : false,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        color:
                            getContrastingTextColor(backgroundColorFromProvider)
                                .withAlpha(150),
                      ),
                    ),
                    maxLines: null,
                    style: GoogleFonts.nunito(
                      color:
                          getContrastingTextColor(backgroundColorFromProvider),
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                    keyboardType: TextInputType.multiline,
                    controller: titleController,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.dateText,
                    style: TextStyle(
                      color:
                          getContrastingTextColor(backgroundColorFromProvider)
                              .withAlpha(200),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autofocus: true,
                    enabled: isEditMode ? true : false,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Type something...',
                      hintStyle: TextStyle(
                        color:
                            getContrastingTextColor(backgroundColorFromProvider)
                                .withAlpha(150),
                      ),
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: contentController,
                    style: GoogleFonts.nunito(
                      color:
                          getContrastingTextColor(backgroundColorFromProvider),
                      fontSize: 23,
                    ),
                  ),
                  const SizedBox(height: 61),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: isEditMode ? BackgroundColorSelector() : const SizedBox(),
    );
  }

  Future<void> _deleteDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            'You sure you want to delete this note?',
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () async {
                try {
                  await NoteController().deleteNoteById(newNoteId!);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Note deleted!"),
                    ),
                  );

                  Navigator.pop(context);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("A error occurred! ${e.toString()}"),
                    ),
                  );
                }
              },
              child: Text(
                'Yes',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                ),
              ),
            ),
            FilledButton.tonal(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'No',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
