import 'package:finale_project/models/group.dart';
import 'package:flutter/material.dart';
import '../services/group_service.dart';

class GroupsProvider with ChangeNotifier {
  final List<Group> _groups = [];
  final GroupService _groupService = GroupService();

  List<Group> get groups => _groups;

  Future<void> addGroup(Group group) async {
    final savedGroup = await _groupService.addGroup(group);
    _groups.add(savedGroup);
    notifyListeners();
  }

  Future<void> loadGroups() async {
    final loadedGroups = await _groupService.getGroups();
    _groups.clear();
    _groups.addAll(loadedGroups);
    notifyListeners();
  }

  Future<void> updateGroup(Group group) async {
    await _groupService.updateGroup(group);
    final index = _groups.indexWhere((f) => f.id == group.id);
    if (index != -1) {
      _groups[index] = group;
      notifyListeners();
    }
  }

  Future<void> deleteGroup(String id) async {
    await _groupService.deleteGroup(id);
    _groups.removeWhere((f) => f.id == id);
    notifyListeners();
  }
}