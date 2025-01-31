import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class ShimmerNoteList extends StatelessWidget {
  const ShimmerNoteList({super.key});

  @override
  Widget build(BuildContext context) {
    return WaterfallFlow.builder(
      gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 7,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[800]!,
          child: Container(
            height: Random().nextInt(150) + 100, // size between 100 and 250
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(150),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white24,
              ),
            ),
          ),
        );
      },
    );
  }
}
