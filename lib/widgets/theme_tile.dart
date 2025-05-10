import 'package:flutter/material.dart';

class ThemeSwitchTile extends StatelessWidget {
    final bool isDarkMode;
    final ValueChanged<bool> onChanged;

    const ThemeSwitchTile({
        super.key,
        required this.isDarkMode,
        required this.onChanged
    });

    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
                children: [
                    Icon(
                      isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                      size: 28.0,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                        child: Text(
                            isDarkMode ? "Dark Mode" : "Light Mode",
                            style: Theme.of(context).textTheme.bodyLarge
                        )
                    ),
                    Switch(
                        value: isDarkMode,
                        onChanged: onChanged
                    )
                ]
            )
        );
    }

}
