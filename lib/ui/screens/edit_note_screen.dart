import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/ui/providers/edit_mode_provider.dart';
import 'package:notes_app/ui/widgets/app_bar_button.dart';

class NoteFields {
  final String titleController;
  final String dateController;
  final String contentController;

  NoteFields(this.titleController, this.dateController, this.contentController);
}

class EditNoteScreen extends ConsumerWidget {
  final String titleText;
  final String dateText;
  final String contentText;
  final Color backgroundColor;
  const EditNoteScreen({
    super.key,
    required this.titleText,
    required this.contentText,
    required this.dateText,
    required this.backgroundColor,
  });

  Color getContrastingTextColor(Color color) {
    double luminance = color.computeLuminance();
    return (luminance + 0.1) > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController(text: titleText);
    final contentController = TextEditingController(text: contentText);
    final dateController = TextEditingController(text: dateText);

    final isEditMode = ref.watch(editModeProvider);

    // function executed after the widget is builded. Used to enable the
    // editMode if is a new note (the textfields are empty)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (titleText.isEmpty && contentText.isEmpty) {
        ref.read(editModeProvider.notifier).state = true;
      }
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        toolbarHeight: 86,
        actions: [
          const SizedBox(width: 24),
          AppBarButton(
            function: () => Navigator.pop(context),
            icon: Icons.arrow_back,
          ),
          Expanded(child: Container()),
          AppBarButton(
            function: () {
              ref.read(editModeProvider.notifier).state = !isEditMode;
            },
            icon: isEditMode ? Icons.save : Icons.edit,
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            TextFormField(
              enabled: isEditMode ? true : false,
              decoration: InputDecoration.collapsed(hintText: 'Title'),
              maxLines: null,
              style: GoogleFonts.nunito(
                color: getContrastingTextColor(backgroundColor),
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
              keyboardType: TextInputType.multiline,
              controller: titleController,
            ),
            const SizedBox(height: 20),
            dateController.text.isNotEmpty
                ? Text(
                    dateController.text,
                    style: TextStyle(
                      color: getContrastingTextColor(backgroundColor),
                    ),
                  )
                : SizedBox(),
            const SizedBox(height: 20),
            TextFormField(
              enabled: isEditMode ? true : false,
              decoration:
                  InputDecoration.collapsed(hintText: 'Type something...'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: contentController,
              style: GoogleFonts.nunito(
                color: getContrastingTextColor(backgroundColor),
                fontSize: 23,
              ),
            ),
            const SizedBox(height: 61),
          ],
        ),
      ),
    );
  }
}
