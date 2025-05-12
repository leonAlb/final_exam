import 'package:finale_project/providers/settings_provider.dart';
import 'package:finale_project/widgets/friend_dialog.dart';
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
    bool isLoading = true;
    int friendsToLoad = 8;

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
        final friends = friendsProvider.friends.take(friendsToLoad).toList();
        final settingsProvider = Provider.of<SettingsProvider>(context);

        return Scaffold(
            appBar: AppBar(title: const Text("Friends"), centerTitle: true),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                        Expanded(
                            child: ListView.builder(
                                itemCount: friends.length,
                                itemBuilder: (context, index) {
                                    final friend = friends[index];
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: settingsProvider.isDarkMode ? Colors.grey[850] : Colors.grey[100],
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                    BoxShadow(
                                                        color: settingsProvider.isDarkMode
                                                            ? Color.fromRGBO(255, 255, 255, 0.125)
                                                            : Color.fromRGBO(0, 0, 0, 0.125),
                                                        spreadRadius: 2,
                                                        blurRadius: 6,
                                                        offset: const Offset(0, 3)
                                                    )
                                                ]
                                            ),
                                            child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                        Row(
                                                            children: [
                                                                CircleAvatar(backgroundImage: AssetImage(friend.avatar)),
                                                                const SizedBox(width: 15),
                                                                Text(
                                                                    friend.name,
                                                                    style: const TextStyle(fontWeight: FontWeight.bold)
                                                                )
                                                            ]
                                                        ),
                                                        Row(
                                                            children: [
                                                                IconButton(
                                                                    icon: RelationNames.getRelationIcon(friend.relation),
                                                                    color: friend.isHighlighted ? Colors.red : Colors.grey,
                                                                    onPressed: () {
                                                                        Provider.of<FriendsProvider>(context, listen: false)
                                                                            .toggleHighlight(friend);
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
                                            )
                                        )
                                    );
                                }
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    if (friends.length < friendsProvider.friends.length)
                                    ElevatedButton.icon(
                                        onPressed: () {
                                            setState(() {
                                                    friendsToLoad += friendsToLoad;
                                                });
                                        },
                                        icon: Icon(Icons.add),
                                        label: const Text("Load More Friends"),
                                        iconAlignment: IconAlignment.end,
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0)
                                        )
                                    ),
                                    Spacer(),
                                    ElevatedButton.icon(
                                        onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (_) => const FriendDialog()
                                            );
                                        },
                                        icon: Icon(Icons.person_add_alt_1),
                                        label: const Text("Add Friend"),
                                        iconAlignment: IconAlignment.start,
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0) // Same padding as above
                                        )
                                    )
                                ]
                            )
                        )
                    ]
                )
        );
    }
}