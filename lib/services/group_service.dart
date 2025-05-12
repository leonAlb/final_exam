import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group.dart';

class GroupService {
  final CollectionReference groupsCollection = FirebaseFirestore.instance.collection('groups');

  Future<Group> addGroup(Group group) async {
    final docRef = await groupsCollection.add(group.toMap());
    return group.copyWith(id: docRef.id);
  }

  Future<List<Group>> getGroups() async {
    final snapshot = await groupsCollection.get();
    return snapshot.docs.map((doc) => Group.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> deleteGroup(String id) {
    return groupsCollection.doc(id).delete();
  }

  Future<void> updateGroup(Group group) {
    return groupsCollection.doc(group.id).update(group.toMap());
  }
}
