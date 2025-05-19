import 'package:finale_project/providers/groups_provider.dart';
import 'package:finale_project/screens/expenses.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/box_decoration.dart';
import '../widgets/load_button_bar.dart';
import '../widgets/search_bar.dart';
import 'create_group.dart';

class GroupScreen extends StatefulWidget {
    const GroupScreen({super.key});

    @override
    GroupsScreenState createState() => GroupsScreenState();
}

class GroupsScreenState extends State<GroupScreen> {
    bool isLoading = true;
    int groupsToLoad = 7;
    String searchQuery = '';

    @override
    void initState() {
        super.initState();
        _loadGroups();
    }

    Future<void> _loadGroups() async {
        await Provider.of<GroupsProvider>(context, listen: false).loadGroups();
        setState(() {
                isLoading = false;
            });
    }

    @override
    Widget build(BuildContext context) {
        final settingsProvider = Provider.of<SettingsProvider>(context);
        final groupsProvider = Provider.of<GroupsProvider>(context);
        final allGroups = groupsProvider.groups;
        final filteredGroups = allGroups
            .where((group) =>
                group.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .take(groupsToLoad)
            .toList();
        String username = settingsProvider.username;

        return Scaffold(
            appBar: AppBar(
                title: Text("Welcome, $username"),
                centerTitle: true
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                        CustomSearchBar(
                            label: "Search Groups",
                            onChanged: (value) {
                                setState(() {
                                        searchQuery = value.toLowerCase();
                                    });
                            }
                        ),
                        Expanded(
                            child: allGroups.isEmpty
                                ? const Center(
                                    child: Text(
                                        'No groups yet',
                                        style: TextStyle(fontSize: 16, color: Colors.grey)
                                    )
                                )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: filteredGroups.length,
                                    itemBuilder: (context, index) {
                                        final group = filteredGroups[index];
                                        return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 6),
                                            child: InkWell(
                                                onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => GroupExpensesScreen(groupId: group.id))
                                                ),
                                                child: Container(
                                                    decoration: getBoxDecoration(settingsProvider.isDarkMode),
                                                    child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Expanded(
                                                                    child: Text(
                                                                        group.name,
                                                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: 1
                                                                    )
                                                                ),
                                                                SizedBox(width: 15),
                                                                Row(
                                                                    children: [
                                                                        Text("Members: ${group.memberIds.length}"),
                                                                        const SizedBox(width: 5),
                                                                        IconButton(
                                                                            icon: const Icon(Icons.delete),
                                                                            onPressed: () {
                                                                                groupsProvider.deleteGroup(group.id);
                                                                                setState(() {});
                                                                            },
                                                                            padding: EdgeInsets.zero,
                                                                            visualDensity: VisualDensity.compact
                                                                        )
                                                                    ]
                                                                )
                                                            ]
                                                        )
                                                    )
                                                )
                                            )
                                        );
                                    }
                                )
                        ),
                        LoadButtonBar(
                            loadMoreLabel: "Load More Groups",
                            canLoadMore: filteredGroups.length < allGroups.length,
                            onLoadMore: () {
                                setState(() {
                                        groupsToLoad += groupsToLoad;
                                    });
                            },
                            createLabel: "Create Group",
                            createIcon: Icons.group_add_rounded,
                            onCreate: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const CreateGroupScreen())
                                );
                            }
                        )
                    ]
                )
        );

    }
}

