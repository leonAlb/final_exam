import 'package:finale_project/providers/settings_provider.dart';
import 'package:finale_project/widgets/friend_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friends_provider.dart';
import '../widgets/box_decoration.dart';
import '../utils/static_data.dart';
import '../widgets/load_button_bar.dart';
import '../widgets/search_bar.dart';

class FriendsScreen extends StatefulWidget {
    const FriendsScreen({super.key});

    @override
    FriendsScreenState createState() => FriendsScreenState();
}

class FriendsScreenState extends State<FriendsScreen> {
    bool isLoading = true;
    int friendsToLoad = 7;
    String searchQuery = "";

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
        final filteredFriends = friends
            .where((friend) => friend.name.toLowerCase().contains(searchQuery))
            .take(friendsToLoad)
            .toList();
        final settingsProvider = Provider.of<SettingsProvider>(context);

        return Scaffold(
            appBar: AppBar(title: const Text("Friends"), centerTitle: true),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                        CustomSearchBar(
                            label: "Search Friends",
                            onChanged: (value) {
                                setState(() {
                                        searchQuery = value.toLowerCase();
                                    });
                            }
                        ),
                        Expanded(
                            child: friends.isEmpty
                                ? const Center(
                                    child: Text(
                                        'No Friends yet',
                                        style: TextStyle(fontSize: 16, color: Colors.grey)
                                    )
                                )
                                : ListView.builder(
                                    padding: EdgeInsets.only(top: 5),
                                    itemCount: filteredFriends.length,
                                    itemBuilder: (context, index) {
                                        final friend = filteredFriends[index];
                                        return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                            child: Container(
                                                decoration: getBoxDecoration(settingsProvider.isDarkMode),
                                                child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                            Expanded(
                                                                child: Row(
                                                                    children: [
                                                                        CircleAvatar(backgroundImage: AssetImage(friend.avatar)),
                                                                        const SizedBox(width: 15),
                                                                        Flexible(
                                                                            child: Text(
                                                                                friend.name,
                                                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 1
                                                                            )
                                                                        )
                                                                    ]
                                                                )
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
                        LoadButtonBar(
                            canLoadMore: filteredFriends.length < friendsProvider.friends.length,
                            onLoadMore: () {
                                setState(() {
                                        friendsToLoad += friendsToLoad;
                                    });
                            },
                            loadMoreLabel: "Load More Friends",
                            onCreate: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => const FriendDialog()
                                );
                            },
                            createIcon: Icons.person_add_alt_1,
                            createLabel: "Add Friend"
                        )
                    ]
                )
        );
    }
}