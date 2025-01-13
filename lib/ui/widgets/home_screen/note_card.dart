import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final Color color;
  final String title;
  final String date;
  const NoteCard(
      {super.key,
      required this.color,
      required this.title,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                // color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              date,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
