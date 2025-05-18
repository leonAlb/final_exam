import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../utils/widget_utils.dart';
import '../widgets/avatar_tile.dart';
import '../widgets/dropdown_tile.dart';
import '../widgets/textedit_tile.dart';
import '../widgets/theme_tile.dart';
import '../utils/static_data.dart';

class SettingsScreen extends StatelessWidget {
    const SettingsScreen({super.key});

    @override
    Widget build(BuildContext context) {
        final settingsProvider = Provider.of<SettingsProvider>(context);
        final username = settingsProvider.username;
        final email = settingsProvider.email;
        final password = settingsProvider.password;
        final avatarImages = AvatarFilenames.avatars;

        final items = [
            AvatarDropdownTile(
                label: 'My Picture',
                value: settingsProvider.selectedAvatar,
                avatarImages: avatarImages,
                onChanged: (newAvatar) {
                    if (newAvatar != null) {
                        settingsProvider.updateSelectedAvatar(newAvatar);
                    }
                }
            ),
            EditableTile(
                icon: Icons.person,
                label: username,
                onEdit: () => showEditDialog(
                    context,
                    title: 'Change Username',
                    initialValue: username,
                    onSave: settingsProvider.updateUsername
                )
            ),
            EditableTile(
                icon: Icons.email,
                label: email,
                onEdit: () => showEditDialog(
                    context,
                    title: 'Change Email',
                    initialValue: email,
                    onSave: settingsProvider.updateEmail
                )
            ),
            EditableTile(
                icon: Icons.key,
                label: '*' * password.length,
                onEdit: () => showSecureEditDialog(
                    context,
                    title: 'Change Password',
                    onSave: settingsProvider.updatePassword
                )
            ),
            ThemeSwitchTile(
                isDarkMode: settingsProvider.isDarkMode,
                onChanged: settingsProvider.toggleTheme
            ),
            DropdownTile(
                icon: Icons.palette,
                label: "Color Theme",
                value: settingsProvider.colorTheme,
                onChanged: (value) {
                    if (value != null) {
                        settingsProvider.updateColorTheme(value);
                    }
                },
                items: ColorNames.dropdownItems
            ),
            DropdownTile(
                icon: Icons.attach_money,
                label: "Currency",
                value: settingsProvider.currency,
                onChanged: (value) {
                    if (value != null) {
                        settingsProvider.updateCurrency(value);
                    }
                },
                items: CurrencyNames.dropdownItems
            )
        ];

        return Scaffold(
            appBar: AppBar(
                title: const Text("Settings"),
                centerTitle: true
            ),
            body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 20, thickness: 5),
                    itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: items[index]
                    )
                )
            )
        );
    }
}
