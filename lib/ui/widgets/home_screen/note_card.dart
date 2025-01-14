import 'package:flutter/material.dart';
import 'package:notes_app/ui/screens/edit_note_screen.dart';

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
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditNoteScreen(
                titleText: title,
                contentText:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam nisi justo, tempor a faucibus vel, gravida nec diam. Aliquam posuere nisi ex, vitae posuere libero elementum sit amet. Nunc a metus sit amet lorem auctor tincidunt. Fusce erat arcu, pretium vitae posuere a, aliquam sed magna. Fusce blandit cursus gravida. Cras elementum a velit ut dictum. Vestibulum mattis tortor tortor, in facilisis magna finibus quis. Proin sit amet dui ac lectus convallis commodo. Suspendisse auctor pellentesque gravida. Quisque elit nunc, tempus molestie ligula non, placerat tempus enim. Curabitur finibus fringilla ipsum, non elementum justo suscipit at. Duis in massa vitae enim sollicitudin interdum. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nulla mollis non orci eget facilisis. Curabitur sit amet sem lorem. Vestibulum vel justo et velit tincidunt feugiat commodo in metus. Mauris mi elit, suscipit at tempus vel, auctor et quam. Aliquam sodales mi eget ipsum ultricies finibus. Sed malesuada vestibulum lobortis. Maecenas et justo efficitur, gravida quam eu, tristique dolor. Sed nec leo egestas, maximus dolor ut, maximus purus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum sit amet augue et massa ultricies rhoncus ac eget lectus. Cras dictum molestie tincidunt. Donec aliquet, orci vel tincidunt blandit, massa ligula mollis nibh, in tempus erat lacus eu erat.',
                dateText: date,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
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
        ),
      ),
    );
  }
}
