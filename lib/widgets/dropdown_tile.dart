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
        return ListTile(
            leading: Icon(icon),
            title: Text(label),
            trailing: DropdownButton<String>(
                value: value,
                onChanged: onChanged,
                items: items
            )
        );
    }
}
