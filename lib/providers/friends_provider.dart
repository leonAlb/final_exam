import 'package:flutter/material.dart';
import '../models/friend.dart';
import '../services/friend_service.dart';

class FriendsProvider with ChangeNotifier {
  final List<Friend> _friends = [];
  final FriendService _friendService = FriendService();

  List<Friend> get friends => _friends;

  Future<void> addFriend(Friend friend) async {
    final savedFriend = await _friendService.addFriend(friend);
    _friends.add(savedFriend);
    _sortFriends();
    notifyListeners();
  }

  Future<void> loadFriends() async {
    final loadedFriends = await _friendService.getFriends();
    _friends.clear();
    _friends.addAll(loadedFriends);
    _sortFriends();
    notifyListeners();
  }

  Future<void> updateFriend(Friend friend) async {
    await _friendService.updateFriend(friend);
    final index = _friends.indexWhere((f) => f.id == friend.id);
    if (index != -1) {
      _friends[index] = friend;
      notifyListeners();
    }
  }

  Future<void> deleteFriend(String id) async {
    await _friendService.deleteFriend(id);
    _friends.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  Future<void> toggleHighlight(Friend friend) async {
    final updatedFriend = friend.copyWith(isHighlighted: !friend.isHighlighted);
    await _friendService.updateFriend(updatedFriend);
    final index = _friends.indexWhere((f) => f.id == friend.id);
    if (index != -1) {
      _friends[index] = updatedFriend;
      _sortFriends();
      notifyListeners();
    }
  }

  void _sortFriends() {
    _friends.sort((a, b) {
      if (a.isHighlighted == b.isHighlighted) {
        return 0;
      }
      return a.isHighlighted ? -1 : 1;
    });
  }
}

