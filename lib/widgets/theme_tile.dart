import 'package:flutter/material.dart';

class ThemeSwitchTile extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  const ThemeSwitchTile({
    super.key,
    required this.isDarkMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(isDarkMode ? "Dark Mode" : "Light Mode"),
      value: isDarkMode,
      onChanged: onChanged,
      secondary: Icon(
        isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
        color: isDarkMode ? Colors.yellow : Colors.orange,
      ),
    );
  }
}
