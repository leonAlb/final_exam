import 'package:flutter/material.dart';

Color getColor(String theme, bool isDark) {
  switch (theme) {
    case 'Green':
      return isDark ? Color(0xFF09370D) : Color(0x7D7BFF7B);
    case 'Blue':
      return isDark ? Color(0x7D071751) : Color(0x7D3E69FF);
    case 'Red':
      return isDark ? Color(0x7D5E0404) : Colors.red;
    case 'Orange':
      return isDark ? Color(0x7D602601) : Colors.orange;
    case 'Purple':
      return isDark ? Color(0x7D38004C) : Colors.purple;
    default:
      return isDark ? Colors.white : Colors.black;
  }
}
