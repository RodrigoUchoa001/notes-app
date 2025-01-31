import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/ui/providers/note_background_color_provider.dart';

class BackgroundColorSelector extends ConsumerWidget {
  BackgroundColorSelector({super.key});

  final colors = [
    Color(0xFF252525),
    Colors.white,
    Colors.redAccent.shade100,
    Colors.lightBlueAccent.shade100,
    Colors.purple.shade300,
    Colors.pinkAccent.shade100,
    Colors.green.shade300,
    Colors.indigo,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Color(0xFF252525),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: colors.map(
            (color) {
              return IconButton(
                onPressed: () {
                  ref.read(noteBackgroundColorProvider.notifier).state = color;
                },
                icon: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
