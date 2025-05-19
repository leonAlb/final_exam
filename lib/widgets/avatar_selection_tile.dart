import 'package:flutter/material.dart';

class AvatarDropdownTile extends StatelessWidget {
    final String label;
    final String value;
    final List<String> avatarImages;
    final ValueChanged<String?> onChanged;

    const AvatarDropdownTile({
        super.key,
        required this.label,
        required this.value,
        required this.avatarImages,
        required this.onChanged
    });

    @override
    Widget build(BuildContext context) {
      final String selected =
      avatarImages.contains(value) ? value : avatarImages[0];

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(selected),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            DropdownButton<String>(
              value: selected,
              onChanged: onChanged,
              icon: const Icon(Icons.arrow_drop_down),
              underline: const SizedBox(),
              items: avatarImages.map((avatarPath) {
                return DropdownMenuItem<String>(
                  value: avatarPath,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(avatarPath),
                  ),
                );
              }).toList(),
              selectedItemBuilder: (context) {
                return avatarImages.map((_) {
                  return const Center(
                    child: Text(
                      'Change',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
      );
    }
}
