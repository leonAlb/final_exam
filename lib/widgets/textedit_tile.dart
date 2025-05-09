import 'package:flutter/material.dart';

class EditableTile extends StatelessWidget {
    final IconData icon;
    final String label;
    final VoidCallback onEdit;

    const EditableTile({super.key, required this.icon, required this.label, required this.onEdit
    });

    @override
    Widget build(BuildContext context) {
        return ListTile(
            leading: Icon(icon),
            title: Text(label),
            trailing: ElevatedButton(
                onPressed: onEdit,
                child: const Text("Change")
            )
        );
    }
}
