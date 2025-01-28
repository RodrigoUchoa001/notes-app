import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/utils.dart';

class NoteCard extends ConsumerWidget {
  final Color color;
  final String title;
  final String date;
  final String content;
  final String noteId;
  const NoteCard(
      {super.key,
      required this.color,
      required this.title,
      required this.date,
      required this.content,
      required this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white24,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title.isNotEmpty
                ? Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      color: getContrastingTextColor(color),
                      // color: Colors.black,
                    ),
                  )
                : Text(
                    "No title",
                    style: TextStyle(
                      fontSize: 18,
                      color: getContrastingTextColor(color).withAlpha(230),
                      fontStyle: FontStyle.italic,
                      // color: Colors.black,
                    ),
                  ),
            const SizedBox(height: 16),
            Text(
              date,
              style: TextStyle(
                fontSize: 12,
                color: getContrastingTextColor(color).withAlpha(200),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
