import 'package:flutter/material.dart';

class DropdownTile extends StatelessWidget {
    final IconData icon;
    final String label;
    final String value;
    final List<DropdownMenuItem<String>> items;
    final ValueChanged<String?> onChanged;

    const DropdownTile({
        super.key, required this.icon, required this.label, required this.value, required this.items, required this.onChanged
    });

    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
                children: [
                    Icon(icon, size: 28.0),
                    const SizedBox(width: 16),
                    Expanded(
                        child: Text(
                            label,
                            style: Theme.of(context).textTheme.bodyLarge,
                        ),
                    ),
                    DropdownButton<String>(
                        value: value,
                        onChanged: onChanged,
                        items: items,
                    ),
                ],
            ),
        );
    }
}
