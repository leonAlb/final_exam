import 'package:finale_project/firebase_options.dart';
import 'package:finale_project/providers/friends_provider.dart';
import 'package:finale_project/screens/friends.dart';
import 'package:finale_project/utils/theme_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/settings_provider.dart';
import 'screens/settings.dart';
import 'screens/groups.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider( // MultiProvider ermöglicht die Nutzung mehrerer Provider
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()..loadSettings()), // SettingsProvider
        ChangeNotifierProvider(create: (_) => FriendsProvider()), // Hier der FriendsProvider
      ],
      child: const CostaSplit(), // Deine Haupt-App
    ),
  );
}

class CostaSplit extends StatelessWidget {
    const CostaSplit({super.key});

    @override
    Widget build(BuildContext context) {
        final settingsProvider = Provider.of<SettingsProvider>(context);
        final isDark = settingsProvider.isDarkMode;
        final theme = settingsProvider.colorTheme;
        Color desiredColor = getColor(theme, isDark);

        return MaterialApp(
            theme: ThemeData(
                brightness: isDark ? Brightness.dark : Brightness.light,
                useMaterial3: true,
                colorSchemeSeed: desiredColor,
                appBarTheme: AppBarTheme(
                    backgroundColor: desiredColor,
                    titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)
                )
            ),
            home: const HomeScreen()
        );
    }
}

class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    int _selectedIndex = 1;

    final List<Widget> _screens = <Widget>[
        SettingsScreen(),
        HomeTab(),
        FriendsScreen()
    ];

    void _onItemTapped(int index) {
        setState(() {
                _selectedIndex = index;
            });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: _screens[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Settings'
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.group),
                        label: 'Group'
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.handshake),
                        label: 'Friends'
                    )
                ]
            )
        );
    }
}

