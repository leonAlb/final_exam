import 'package:flutter/material.dart';

BoxDecoration getBoxDecoration(bool isDarkMode) {
  return BoxDecoration(
    color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: isDarkMode
            ? const Color.fromRGBO(255, 255, 255, 0.050)
            : const Color.fromRGBO(0, 0, 0, 0.250),
        spreadRadius: 2,
        blurRadius: 6,
        offset: const Offset(0, 3),
      ),
    ],
  );
}
