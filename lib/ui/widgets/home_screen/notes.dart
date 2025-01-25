import 'package:flutter/material.dart';
import 'package:notes_app/controllers/note_controller.dart';
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
        'content': 'abcder'
      },
      {
        'title': 'Beautiful weather app UI concepts we wish existed',
        'date': 'May 21, 2020',
        'color': Colors.redAccent.shade100,
        'content': 'asdasdasfasfasd'
      },
      {
        'title':
            "Spotify's Reema Bhagat on product design, music, and the key to a happy carrer",
        'date': 'Feb 01, 2020',
        'color': Colors.lightBlueAccent.shade100,
        'content': '523523242343'
      },
      {
        'title': "12 eye-catching mobile wallpaper",
        'date': 'Feb 01, 2020',
        'color': Colors.purple.shade300,
        'content': '2c3423r2q3c5r2c'
      },
      {
        'title': "Design For Good: Join The Face Mask Challenge",
        'date': 'Feb 01, 2020',
        'color': Colors.pinkAccent.shade100,
        'content': 'f20935029//*-/-*/'
      },
      {
        'title': "eye-catching mobile wallpaper",
        'date': 'Feb 01, 2020',
        'color': Colors.green.shade300,
        'content': '340j243598h428952h12312*/-'
      },
    ];

    return FutureBuilder(
      future: NoteController().getNotes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("ERRO: ${snapshot.error.toString()}"),
          );
        } else if (snapshot.data!.isEmpty) {
          return Center(
            child: const Text("NENHUMA NOTA"),
          );
        }
        return WaterfallFlow.builder(
          gridDelegate:
              const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Número de colunas
            crossAxisSpacing: 12, // Espaçamento horizontal
            mainAxisSpacing: 12, // Espaçamento vertical
          ),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final data = snapshot.data![index];
            return NoteCard(
              noteId: data.noteId,
              title: data.title,
              content: data.content,
              color: data.color,
              date: data.dateToString(),
            );
          },
        );
      },
    );
  }
}
