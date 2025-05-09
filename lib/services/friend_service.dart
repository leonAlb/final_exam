import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/friend.dart';

class FriendService {
    final CollectionReference friendsCollection = FirebaseFirestore.instance.collection('friends');

    Future<Friend> addFriend(Friend friend) async {
      final docRef = await friendsCollection.add(friend.toMap());
      return friend.copyWith(id: docRef.id);
    }

    Future<List<Friend>> getFriends() async {
        final snapshot = await friendsCollection.get();
        return snapshot.docs.map((doc) => Friend.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
    }

    Future<void> deleteFriend(String id) {
        return friendsCollection.doc(id).delete();
    }

    Future<void> updateFriend(Friend friend) {
        return friendsCollection.doc(friend.id).update(friend.toMap());
    }
}
