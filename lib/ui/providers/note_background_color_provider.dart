import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// controls the note background color.
final noteBackgroundColorProvider =
    StateProvider<Color>((ref) => Color(0xFF252525));
