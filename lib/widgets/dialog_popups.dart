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
        required Function(String) onSave
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
                                    })
                            )
                        )
                    ),
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
    );
}

void showFinishGroupDialog(BuildContext context, VoidCallback onConfirm) {
    final screenWidth = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (context) => Dialog(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        const Text(
                            "Finish Group",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        ),
                        const SizedBox(height: 15),
                        const Text(
                            "Are you sure you want to finish the group?\nThis will delete the group!",
                            textAlign: TextAlign.center
                        ),
                        const SizedBox(height: 25),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                TextButton.icon(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.cancel),
                                    label: const Text("Cancel"),
                                    style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0)
                                    )
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                    onPressed: () {
                                        Navigator.pop(context);
                                        onConfirm();
                                    },
                                    icon: const Icon(Icons.check_circle),
                                    label: const Text("Yes, finish"),
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0)
                                    )
                                )
                            ]
                        )
                    ]
                )
            )
        )
    );
}

