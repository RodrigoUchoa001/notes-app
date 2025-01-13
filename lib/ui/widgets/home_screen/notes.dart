import 'package:flutter/material.dart';
import 'package:notes_app/ui/widgets/home_screen/note_card.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'How to make your personal brand stand out online',
        'date': 'May 21, 2020',
        'color': Colors.redAccent.shade100,
      },
      {
        'title': 'Beautiful weather app UI concepts we wish existed',
        'date': 'May 21, 2020',
        'color': Colors.redAccent.shade100,
      },
      {
        'title':
            "Spotify's Reema Bhagat on product design, music, and the key to a happy carrer",
        'date': 'Feb 01, 2020',
        'color': Colors.lightBlueAccent.shade100,
      },
      {
        'title': "12 eye-catching mobile wallpaper",
        'date': 'Feb 01, 2020',
        'color': Colors.purple.shade300,
      },
      {
        'title': "Design For Good: Join The Face Mask Challenge",
        'date': 'Feb 01, 2020',
        'color': Colors.pinkAccent.shade100,
      },
      {
        'title': "eye-catching mobile wallpaper",
        'date': 'Feb 01, 2020',
        'color': Colors.green.shade300,
      },
    ];

    return WaterfallFlow.builder(
      gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Número de colunas
        crossAxisSpacing: 12, // Espaçamento horizontal
        mainAxisSpacing: 12, // Espaçamento vertical
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return NoteCard(
          color: item['color'] as Color,
          title: item['title'] as String,
          date: item['date'] as String,
        );
      },
    );
  }
}
