import 'package:flutter/material.dart';
import 'package:notes_app/ui/widgets/note_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 86,
        backgroundColor: Colors.transparent,
        titleSpacing: 24,
        title: const Text(
          "Notes",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
        ),
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
                  child: Icon(Icons.search),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: NoteCard(),
      ),
      floatingActionButton: Material(
        color: Colors
            .grey.shade800, // set color here, so the inkwell animation appears
        borderRadius: BorderRadius.circular(32),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(32),
          child: Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(Icons.add, size: 32),
            ),
          ),
        ),
      ),
    );
  }
}
