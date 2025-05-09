import 'package:flutter/material.dart';
import '../models/friend.dart';
import '../services/friend_service.dart';

class FriendsProvider with ChangeNotifier {
  final List<Friend> _friends = [];
  final FriendService _friendService = FriendService();

  List<Friend> get friends => _friends;

  Future<void> addFriend(Friend friend) async {
    await _friendService.addFriend(friend);
    _friends.add(friend);
    notifyListeners();
  }

  Future<void> loadFriends() async {
    final loadedFriends = await _friendService.getFriends();
    _friends.clear();
    _friends.addAll(loadedFriends);
    notifyListeners();
  }

  Future<void> deleteFriend(String id) async {
    await _friendService.deleteFriend(id);
    _friends.removeWhere((f) => f.id == id);
    notifyListeners();
  }
}
