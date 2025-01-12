import 'package:flutter/material.dart';
import 'package:notes_app/ui/widgets/note_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: NoteCard(),
      ),
    );
  }
}
