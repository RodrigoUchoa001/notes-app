import 'package:flutter/material.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Exemplo de dados para simular itens dinâmicos
    final items = List.generate(10, (index) {
      return {
        'title': 'Item ${index + 1}',
        'description': 'Descrição para o item ${index + 1}',
        'color': Colors.primaries[index % Colors.primaries.length],
        'height': 100.0 + (index % 4) * 30.0, // Altura variável
      };
    });

    return WaterfallFlow.builder(
      gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Número de colunas
        crossAxisSpacing: 8, // Espaçamento horizontal
        mainAxisSpacing: 8, // Espaçamento vertical
      ),
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          height: item['height'] as double,
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
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['description'] as String,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
