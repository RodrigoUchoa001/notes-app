import 'package:flutter/material.dart';
import 'package:notes_app/controllers/note_controller.dart';
import 'package:notes_app/ui/widgets/home_screen/note_card.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
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
