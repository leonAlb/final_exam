import 'package:finale_project/widgets/add_friend.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friends_provider.dart';

class FriendsScreen extends StatelessWidget {
    const FriendsScreen({super.key});

    @override
    Widget build(BuildContext context) {
        final friendsProvider = Provider.of<FriendsProvider>(context);
        final friends = friendsProvider.friends;

        return Scaffold(
            appBar: AppBar(title: const Text("Friends")),
            body: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: friends.length,
                itemBuilder: (context, index) {
                    final friend = friends[index];
                    return ListTile(
                        leading: CircleAvatar(
                            backgroundImage: AssetImage(friend.avatar)
                        ),
                        title: Text(friend.name),
                        subtitle: Text(friend.relation)
                    );
                },
                separatorBuilder: (_, __) => const Divider(height: 1)
            ),
            floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddFriendDialog(),
                  );
                },
                label: const Text("Add Friend"),
                icon: const Icon(Icons.person_add)
            )
        );
    }
}
