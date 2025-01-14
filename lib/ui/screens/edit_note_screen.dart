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
  const EditNoteScreen(
      {super.key,
      required this.titleText,
      required this.contentText,
      required this.dateText});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: titleText);
    final contentController = TextEditingController(text: contentText);
    final dateController = TextEditingController(text: dateText);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 86,
        actions: [
          Material(
            color: Colors.grey
                .shade800, // set color here, so the inkwell animation appears
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(Icons.edit),
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
              ),
              keyboardType: TextInputType.multiline,
              controller: titleController,
            ),
            const SizedBox(height: 16),
            Text(dateController.text, style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration.collapsed(hintText: ''),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: contentController,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
