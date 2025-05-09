import 'package:flutter/material.dart';

Color getColor(String theme, bool isDark) {
  switch (theme) {
    case 'Green':
      return isDark ? Colors.green.shade900 : Colors.green;
    case 'Blue':
      return isDark ? Colors.blue.shade900 : Colors.blue;
    case 'Red':
      return isDark ? Colors.red.shade900 : Colors.red;
    case 'Orange':
      return isDark ? Colors.orange.shade900 : Colors.orange;
    case 'Purple':
      return isDark ? Colors.purple.shade900 : Colors.purple;
    default:
      return isDark ? Colors.blue.shade900 : Colors.blue;
  }
}
