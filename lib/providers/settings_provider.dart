import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/static_data.dart';

class SettingsProvider with ChangeNotifier {
  String _username = 'user';
  String _email = 'user@example.com';
  String _password = 'qwertz123';
  bool _isDarkMode = false;
  String _colorTheme = 'Blue';
  String _currency = '\$';
  String _selectedAvatar = AvatarFilenames.avatars[0];

  String get username => _username;
  String get email => _email;
  String get password => _password;
  bool get isDarkMode => _isDarkMode;
  String get colorTheme => _colorTheme;
  String get currency => _currency;
  String get selectedAvatar => _selectedAvatar;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? 'user';
    _email = prefs.getString('email') ?? 'user@example.com';
    _password = prefs.getString('password') ?? 'qwertz123';
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _colorTheme = prefs.getString('colorTheme') ?? 'Blue';
    _currency = prefs.getString('currency') ?? '\$';
    _selectedAvatar = prefs.getString('selectedAvatar') ?? AvatarFilenames.avatars[0];
    notifyListeners();
  }

  Future<void> updateUsername(String value) async {
    _username = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', value);
    notifyListeners();
  }

  Future<void> updateEmail(String value) async {
    _email = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', value);
    notifyListeners();
  }

  Future<void> updatePassword(String value) async {
    _password = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', value);
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  Future<void> updateColorTheme(String value) async {
    _colorTheme = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('colorTheme', value);
    notifyListeners();
  }

  Future<void> updateCurrency(String value) async {
    _currency = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', value);
    notifyListeners();
  }

  Future<void> updateSelectedAvatar(String avatar) async {
    final prefs = await SharedPreferences.getInstance();
    _selectedAvatar = avatar.toLowerCase();
    await prefs.setString('selectedAvatar', _selectedAvatar);
    notifyListeners();
  }

  Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _username = 'user';
    _email = 'user@example.com';
    _password = 'qwertz123';
    _isDarkMode = false;
    _colorTheme = 'Blue';
    _currency = '\$';
    _selectedAvatar = AvatarFilenames.avatars[0];
    notifyListeners();
  }
}
