import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
    final String label;
    final ValueChanged<String> onChanged;
    final TextEditingController? controller;

    const CustomSearchBar({
        super.key,
        required this.label,
        required this.onChanged,
        this.controller
    });

    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    labelText: label,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
                onChanged: onChanged
            )
        );
    }
}
