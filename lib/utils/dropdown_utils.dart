import 'package:flutter/material.dart';

class DropdownUtils {
    static List<DropdownMenuItem<String>> fromStrings(List<String> items) {
        return items
            .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item)
                ))
            .toList();
    }

    static List<DropdownMenuItem<String>> fromMapList(
        List<Map<String, String>> items, {
            required String valueKey,
            required String labelKey
        }) {
        return items
            .map((item) => DropdownMenuItem(
                    value: item[valueKey]!,
                    child: Text(item[labelKey]!)
                ))
            .toList();
    }
}
