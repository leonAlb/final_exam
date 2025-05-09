import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class HomeTab extends StatelessWidget {
    const HomeTab({super.key});

    @override
    Widget build(BuildContext context) {
        final settingsProvider = Provider.of<SettingsProvider>(context);
        String username = settingsProvider.username;

        return Scaffold(
            appBar: AppBar(
                title: Text(
                    "Welcome, $username"
                ),
                centerTitle: true
            ),
            body: const Center(
                child: Text("Group screen content")
            )
        );
    }
}
