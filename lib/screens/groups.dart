import 'package:finale_project/providers/groups_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/load_button_bar.dart';
import 'group_creation.dart';

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
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                                onChanged: (value) {
                                    setState(() {
                                            searchQuery = value;
                                        });
                                },
                                decoration: InputDecoration(
                                    labelText: 'Search Groups',
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                                )
                            )
                        ),
                        Expanded(
                            child: ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: filteredGroups.length,
                                itemBuilder: (context, index) {
                                    final group = filteredGroups[index];
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: settingsProvider.isDarkMode ? Colors.grey[850] : Colors.grey[100],
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                    BoxShadow(
                                                        color: settingsProvider.isDarkMode
                                                            ? Color.fromRGBO(255, 255, 255, 0.050)
                                                            : Color.fromRGBO(0, 0, 0, 0.250),
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
                                                                Text("Teilnehmer: ${group.memberIds.length}"),
                                                                SizedBox(width: 5),
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
                                    );
                                }
                            )
                        ),
                        BottomButtonBar(
                            canLoadMore: filteredGroups.length < allGroups.length,
                            onLoadMore: () {
                                setState(() {
                                        groupsToLoad += 8;
                                    });
                            },
                            loadMoreLabel: "Load More Groups",
                            onCreate: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const CreateGroupScreen())
                                );
                            },
                            createIcon: Icons.group_add_rounded,
                            createLabel: "Create Group"
                        )
                    ]
                )
        );

    }
}

