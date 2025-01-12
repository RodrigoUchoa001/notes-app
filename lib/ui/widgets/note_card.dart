import 'package:flutter/material.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key});

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
        return Container(
          decoration: BoxDecoration(
            color: item['color'] as Color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    // color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item['date'] as String,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
