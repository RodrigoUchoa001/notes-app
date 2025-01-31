import 'package:flutter/material.dart';

// get a contransting color to use in texts
Color getContrastingTextColor(Color color) {
  double luminance = color.computeLuminance();
  return (luminance + 0.15) > 0.5 ? Colors.black : Colors.white;
}
