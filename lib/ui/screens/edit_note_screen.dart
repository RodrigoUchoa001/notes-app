import 'package:flutter/material.dart';

class NoteFields {
  final String titleController;
  final String dateController;
  final String contentController;

  NoteFields(this.titleController, this.dateController, this.contentController);
}

class EditNoteScreen extends StatelessWidget {
  final String titleText;
  final String dateText;
  final String contentText;
  final Color backgroundColor;
  const EditNoteScreen(
      {super.key,
      required this.titleText,
      required this.contentText,
      required this.dateText,
      required this.backgroundColor});

  Color getContrastingTextColor(Color color) {
    double luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: titleText);
    final contentController = TextEditingController(text: contentText);
    final dateController = TextEditingController(text: dateText);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        toolbarHeight: 86,
        actions: [
          Material(
            color: Color(
                0xFF3B3B3B), // set color here, so the inkwell animation appears
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Icon(Icons.edit, size: 24),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration.collapsed(hintText: ''),
              maxLines: null,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: getContrastingTextColor(backgroundColor),
              ),
              keyboardType: TextInputType.multiline,
              controller: titleController,
            ),
            const SizedBox(height: 16),
            Text(dateController.text,
                style:
                    TextStyle(color: getContrastingTextColor(backgroundColor))),
            const SizedBox(height: 16),
            Divider(),
            TextFormField(
              decoration: InputDecoration.collapsed(hintText: ''),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: contentController,
              style: TextStyle(
                color: getContrastingTextColor(backgroundColor),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
