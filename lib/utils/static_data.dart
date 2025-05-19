import 'package:flutter/material.dart';

class AvatarFilenames {
    static const String basePath = 'assets/images/avatars/';

    static const List<String> avatars = [
        '${basePath}default.png',
        '${basePath}avatar1.png',
        '${basePath}avatar2.png',
        '${basePath}avatar3.png',
        '${basePath}avatar4.png',
        '${basePath}avatar5.png'
    ];
}

class RelationNames {
    static const List<String> relations = [
        'Friend',
        'Family',
        'Contact'
    ];

    static List<DropdownMenuItem<String>> get dropdownItems =>
    fromStrings(relations);

    static Icon getRelationIcon(String relation) {
        switch (relation) {
            case 'Family':
                return const Icon(Icons.family_restroom);
            case 'Friend':
                return const Icon(Icons.favorite); 
            case 'Contact':
                return const Icon(Icons.account_circle); 
            default:
            return const Icon(Icons.help);
        }
    }
}

class ColorNames {
    static const List<String> themes = [
        'Blue',
        'Red',
        'Green',
        'Orange',
        'Purple'
    ];

    static List<DropdownMenuItem<String>> get dropdownItems =>
    fromStrings(themes);
}

class CurrencyNames {
    static const List<String> currencies = ['\$', '€', '¥', '£'];

    static List<DropdownMenuItem<String>> get dropdownItems =>
    fromStrings(currencies);
}

List<DropdownMenuItem<String>> fromStrings(List<String> items) {
    return items
        .map((item) => DropdownMenuItem(
        value: item,
        child: Text(item)
    ))
        .toList();
}