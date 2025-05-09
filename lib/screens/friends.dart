import 'package:finale_project/widgets/add_friend.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friends_provider.dart';
import '../utils/static_data.dart';

class FriendsScreen extends StatefulWidget {
    const FriendsScreen({super.key});

    @override
    _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
    Set<String> flashingIcons = {};
    bool isLoading = true;

    @override
    void initState() {
        super.initState();
        _loadFriends();
    }

    Future<void> _loadFriends() async {
        await Provider.of<FriendsProvider>(context, listen: false).loadFriends();
        setState(() {
                isLoading = false;
            });
    }

    @override
    Widget build(BuildContext context) {
        final friendsProvider = Provider.of<FriendsProvider>(context);
        final friends = friendsProvider.friends;

        return Scaffold(
            appBar: AppBar(title: const Text("Friends"), centerTitle: true),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                        final friend = friends[index];
                        return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                            title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Row(
                                        children: [
                                            CircleAvatar(backgroundImage: AssetImage(friend.avatar)),
                                            const SizedBox(width: 15),
                                            Text(friend.name, style: TextStyle(fontWeight: FontWeight.bold))
                                        ]
                                    ),
                                    Row(
                                        children: [
                                            Text(friend.relation, style: const TextStyle(fontStyle: FontStyle.italic)),
                                            IconButton(
                                                icon: RelationNames.getRelationIcon(friend.relation),
                                                color: friend.isHighlighted ? Colors.red : Colors.grey,
                                                onPressed: () {
                                                    Provider.of<FriendsProvider>(context, listen: false).toggleHighlight(friend);
                                                }
                                            ),
                                            IconButton(
                                                icon: const Icon(Icons.delete),
                                                padding: EdgeInsets.zero,
                                                visualDensity: VisualDensity.compact,
                                                onPressed: () {
                                                    friendsProvider.deleteFriend(friend.id);
                                                    setState(() {});
                                                }
                                            ),
                                            IconButton(
                                                icon: const Icon(Icons.edit),
                                                padding: EdgeInsets.zero,
                                                visualDensity: VisualDensity.compact,
                                                onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) => FriendDialog(friendToEdit: friend)
                                                    );
                                                }
                                            )
                                        ]
                                    )
                                ]
                            )
                        );
                    },
                    separatorBuilder: (_, __) => const Divider(height: 20, thickness: 5)
                ),
            floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => const FriendDialog()
                    );
                },
                label: const Text("Add Friend"),
                icon: const Icon(Icons.person_add)
            )
        );
    }
}