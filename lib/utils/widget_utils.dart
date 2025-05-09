import 'package:flutter/material.dart';

void showEditDialog(
    BuildContext context, {
        required String title,
        required String initialValue,
        required Function(String) onSave
    }) {
    final controller = TextEditingController(text: initialValue);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(title),
            content: TextField(controller: controller),
            actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel')
                ),
                ElevatedButton(
                    onPressed: () {
                        onSave(controller.text);
                        Navigator.of(context).pop();
                    },
                    child: const Text('Save')
                )
            ]
        )
    );
}

