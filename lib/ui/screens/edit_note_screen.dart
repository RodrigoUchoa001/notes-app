import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/firebase/controllers/note_controller.dart';
import 'package:notes_app/firebase/data/note_data.dart';
import 'package:notes_app/ui/providers/edit_mode_provider.dart';
import 'package:notes_app/ui/providers/note_background_color_provider.dart';
import 'package:notes_app/ui/providers/note_provider.dart';
import 'package:notes_app/ui/providers/saving_state_provider.dart';
import 'package:notes_app/ui/widgets/app_bar_button.dart';
import 'package:notes_app/ui/widgets/edit_note_screen/background_color_selector.dart';
import 'package:notes_app/utils.dart';

class EditNoteScreen extends ConsumerStatefulWidget {
  const EditNoteScreen({required this.noteData, super.key});
  final NoteData noteData;

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
    titleController.text = widget.noteData.title;
    contentController.text =
        widget.noteData.content == null ? "" : widget.noteData.content!;

    newNoteId = widget.noteData.noteId;
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = ref.watch(editModeProvider);
    final backgroundColorFromProvider = ref.watch(noteBackgroundColorProvider);
    final isSaving = ref.watch(savingStateProvider);

    final user = ref.watch(userProvider);

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
          const SizedBox(width: 8),
          AppBarButton(
            isLoading: isSaving,
            function: () async {
              if (titleController.text.isEmpty &&
                  contentController.text.isEmpty) {
                Fluttertoast.showToast(
                  msg: "Can't save an empty note!",
                );
                return;
              }

              ref.read(editModeProvider.notifier).state = !isEditMode;

              if (isEditMode) {
                ref.read(savingStateProvider.notifier).state = true;
              }

              if (!ref.read(editModeProvider.notifier).state) {
                try {
                  user.when(
                    data: (user) async {
                      final docId = await NoteController().saveNote(
                        title: titleController.text,
                        content: contentController.text,
                        backgroundColor: backgroundColorFromProvider,
                        userId: user!.uid, // Pass user ID here
                        noteId: newNoteId,
                      );

                      newNoteId ??= docId;

                      Fluttertoast.showToast(
                        msg: "Note saved!",
                      );
                      ref.read(savingStateProvider.notifier).state = false;
                    },
                    loading: () {},
                    error: (error, stackTrace) {
                      Fluttertoast.showToast(
                        msg: error.toString(),
                      );
                    },
                  );
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: "A error occurred! ${e.toString()}",
                  );
                  ref.read(savingStateProvider.notifier).state = false;
                }
              }
            },
            icon: isEditMode
                ? FontAwesomeIcons.floppyDisk
                : FontAwesomeIcons.penToSquare,
          ),
          newNoteId != null ? const SizedBox(width: 8) : Container(),
          newNoteId != null
              ? _createPopUpMenu(context, widget.noteData)
              : Container(),
          const SizedBox(width: 24),
        ],
      ),
      body: Hero(
        tag: widget.noteData.noteId ?? 'newNote',
        child: Container(
          color: backgroundColorFromProvider,
          child: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              color: Colors.transparent,
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    enabled: isEditMode,
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
                    widget.noteData.dateToString(),
                    style: TextStyle(
                      color:
                          getContrastingTextColor(backgroundColorFromProvider)
                              .withAlpha(200),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autofocus: true,
                    enabled: isEditMode,
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

  Future<void> _deleteDialog(BuildContext context, NoteData noteData) async {
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
                  await NoteController().deleteNoteById(noteData.noteId!);

                  Fluttertoast.showToast(
                    msg: "Note deleted",
                  );

                  Navigator.pop(context);
                  Navigator.pop(context);
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: "A error occurred! ${e.toString()}",
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

  Future<void> _collabDialog(BuildContext context, NoteData noteData) async {
    final collabController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsOverflowAlignment: OverflowBarAlignment.start,
          title: Text(
            'Manage Collaborators',
            style: GoogleFonts.nunito(
              color: Colors.white,
            ),
          ),
          actions: [
            Text(
              'Collaborators List:',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            FutureBuilder(
              future: noteData.getCollaboratorsNames(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Text('ERROR');
                } else if (snapshot.data!.isEmpty) {
                  return const Text('EMPTY');
                }
                final data = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data!.map(
                    (collabName) {
                      return Text(
                        "\u2022 $collabName",
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                        ),
                      );
                    },
                  ).toList(),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Insert an e-mail below to invite it to collaborate:',
              style: GoogleFonts.nunito(
                color: Colors.white,
              ),
            ),
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Insert a e-mail...',
              ),
              maxLines: null,
              controller: collabController,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () async {
                try {
                  await NoteController().addCollaborator(
                    noteData.noteId!,
                    collabController.text,
                  );

                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: "${collabController.text} is now a collaborator!",
                  );
                } on Exception {
                  Fluttertoast.showToast(
                    msg: "User not found!",
                  );
                }
              },
              child: Text(
                'Invite',
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

  Widget _createPopUpMenu(BuildContext context, NoteData noteData) {
    return Material(
      color: const Color(
          0xFF3B3B3B), // set color here, so the inkwell animation appears
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: PopupMenuButton(
            icon:
                const Icon(FontAwesomeIcons.ellipsisVertical), // Ícone do botão
            onSelected: (String value) {
              switch (value) {
                case 'delete':
                  if (newNoteId != null) {
                    _deleteDialog(context, noteData);
                  }
                  break;
                case 'collab':
                  if (newNoteId != null) {
                    _collabDialog(context, noteData);
                  }
                default:
              }
            },
            itemBuilder: (context) {
              return [
                if (newNoteId != null)
                  PopupMenuItem(
                    value: "delete",
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Icon(FontAwesomeIcons.trashCan, size: 20),
                        ),
                        const Text(
                          'Delete Note',
                        ),
                      ],
                    ),
                  ),
                if (noteData.isOwner)
                  PopupMenuItem(
                    value: "collab",
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Icon(FontAwesomeIcons.userPlus, size: 20),
                        ),
                        const Text(
                          'Manage Collaborators',
                        ),
                      ],
                    ),
                  )
              ];
            },
          ),
        ),
      ),
    );
  }
}
