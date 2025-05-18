import 'package:flutter/material.dart';

class EditableTile extends StatelessWidget {
    final IconData icon;
    final String label;
    final VoidCallback onEdit;

    const EditableTile({super.key, required this.icon, required this.label, required this.onEdit
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
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1
                        )
                    ),
                    ElevatedButton(
                        onPressed: onEdit,
                        child: const Text("Change")
                    )
                ]
            )
        );
    }
}
