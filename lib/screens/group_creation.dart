import 'package:finale_project/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friends_provider.dart';
import '../providers/groups_provider.dart';
import '../models/group.dart';
import '../widgets/search_bar.dart';

class CreateGroupScreen extends StatefulWidget {
    const CreateGroupScreen({super.key});

    @override
    State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
    final TextEditingController _groupNameController = TextEditingController();
    final TextEditingController _searchController = TextEditingController();
    final Set<String> _selectedFriendIds = {};
    bool isLoading = true;
    String _searchQuery = '';
    int friendsToLoad = 6;

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
        final settingsProvider = Provider.of<SettingsProvider>(context);
        final allFriends = friendsProvider.friends;
        final filteredFriends = allFriends
            .where((friend) =>
                friend.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
        final displayedFriends = filteredFriends.take(friendsToLoad).toList();

        return Scaffold(
            appBar: AppBar(
                title: const Text("Create Group"),
                centerTitle: true
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        children: [
                            TextField(
                                controller: _groupNameController,
                                decoration: const InputDecoration(
                                    labelText: 'Groupname', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))))),
                            const SizedBox(height: 20),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Select Group Members:",
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold))),
                            const SizedBox(height: 8),
                            CustomSearchBar(
                                label: "Search Friends",
                                onChanged: (value) {
                                    setState(() {
                                            _searchQuery = value.toLowerCase();
                                        });
                                }
                            ),
                            SizedBox(height: 15),
                            Expanded(
                                child: ListView.builder(
                                    itemCount: displayedFriends.length,
                                    itemBuilder: (context, index) {
                                        final friend = displayedFriends[index];
                                        final isSelected =
                                            _selectedFriendIds.contains(friend.id);
                                        return InkWell(
                                            onTap: () {
                                                setState(() {
                                                        isSelected
                                                            ? _selectedFriendIds.remove(friend.id)
                                                            : _selectedFriendIds.add(friend.id);
                                                    });
                                            },
                                            child: Container(
                                                margin: const EdgeInsets.symmetric(vertical: 4),
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? settingsProvider.isDarkMode
                                                            ? Color.fromRGBO(255, 255, 255, 0.05)
                                                            : Color.fromRGBO(0, 0, 0, 0.05)
                                                        : Colors.transparent,
                                                    borderRadius: BorderRadius.circular(20),
                                                    border: Border.all(
                                                        color: isSelected
                                                            ? (settingsProvider.isDarkMode
                                                                ? Color.fromRGBO(255, 255, 255, 0.25)
                                                                : Color.fromRGBO(0, 0, 0, 0.25))
                                                            : Colors.grey.shade300
                                                    )
                                                ),
                                                child: Row(children: [
                                                        Checkbox(
                                                            value: isSelected,
                                                            onChanged: (_) {
                                                                setState(() {
                                                                        isSelected
                                                                            ? _selectedFriendIds.remove(friend.id)
                                                                            : _selectedFriendIds.add(friend.id);
                                                                    });
                                                            }),
                                                        CircleAvatar(
                                                            backgroundImage: AssetImage(friend.avatar),
                                                            radius: 20),
                                                        const SizedBox(width: 12),
                                                        Flexible(
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                    Text(friend.name,
                                                                        style: const TextStyle(
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.w500),
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: 1),
                                                                    Text(friend.relation,
                                                                        style: const TextStyle(
                                                                            fontSize: 13,
                                                                            color: Colors.grey))
                                                                ])
                                                        )
                                                    ])
                                            )
                                        );
                                    })
                            )
                        ]
                    )
                ),
            bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                    children: [
                        Expanded(
                            child: ElevatedButton.icon(
                                icon: filteredFriends.length > friendsToLoad
                                    ? const Icon(Icons.add)
                                    : const Icon(Icons.check_circle_outline),
                                label: Text(
                                    filteredFriends.length > friendsToLoad
                                        ? "Load More"
                                        : "All Friends Loaded!"
                                ),
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                    backgroundColor: filteredFriends.length > friendsToLoad
                                        ? null
                                        : Colors.grey
                                ),
                                onPressed: filteredFriends.length > friendsToLoad
                                    ? () {
                                        setState(() {
                                                friendsToLoad += friendsToLoad;
                                            });
                                    }
                                    : null
                            )
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                            child: ElevatedButton.icon(
                                icon: const Icon(Icons.check),
                                label: const Text("Create!"),
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50)
                                ),
                                onPressed: () async {
                                    final name = _groupNameController.text.trim();
                                    if (name.isEmpty || _selectedFriendIds.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Please insert a name and select members'))
                                        );
                                        return;
                                    }

                                    final newGroup = Group(
                                        id: '',
                                        name: name,
                                        memberIds: _selectedFriendIds.toList()
                                    );

                                    await Provider.of<GroupsProvider>(context, listen: false).addGroup(newGroup);
                                    Navigator.of(context).pop();
                                }
                            )
                        )
                    ]
                )
            )
        );
    }
}
