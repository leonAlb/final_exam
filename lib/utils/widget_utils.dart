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

void showSecureEditDialog(
    BuildContext context, {
      required String title,
      required Function(String) onSave,
    }) {
  final controller = TextEditingController();
  bool isObscured = true;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            obscureText: isObscured,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() {
                  isObscured = !isObscured;
                }),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );
    },
  );
}


