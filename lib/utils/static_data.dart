import 'package:flutter/material.dart';

import 'dropdown_utils.dart';

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
        'Acquaintance',
    ];

    static List<DropdownMenuItem<String>> get dropdownItems =>
        DropdownUtils.fromStrings(relations);
}

class ColorNames {
    static const List<String> themes = [
        'Blue',
        'Red',
        'Green',
        'Orange',
        'Purple',
    ];

    static List<DropdownMenuItem<String>> get dropdownItems =>
        DropdownUtils.fromStrings(themes);
}

class CurrencyNames {
    static const List<Map<String, String>> currencies = [
        {'code': 'USD', 'label': 'USD - \$'},
        {'code': 'EUR', 'label': 'EUR - €'},
        {'code': 'JPY', 'label': 'JPY - ¥'},
        {'code': 'GBP', 'label': 'GBP - £'},
    ];

    static List<DropdownMenuItem<String>> get dropdownItems =>
        DropdownUtils.fromMapList(currencies, valueKey: 'code', labelKey: 'label');
}