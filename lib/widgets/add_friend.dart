import 'package:finale_project/widgets/textedit_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/friend.dart';
import '../providers/friends_provider.dart';
import '../utils/static_data.dart';
import '../utils/widget_utils.dart';
import '../widgets/avatar_tile.dart';
import '../widgets/dropdown_tile.dart';

class AddFriendDialog extends StatefulWidget {
    const AddFriendDialog({super.key});

    @override
    _AddFriendDialogState createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends State<AddFriendDialog> {
    final TextEditingController nameController = TextEditingController();
    final avatarImages = AvatarFilenames.avatars;
    final relationItems = RelationNames.relations;

    @override
    Widget build(BuildContext context) {
        String selectedAvatar = avatarImages.first;
        String chosenName = '';
        String chosenRelation = relationItems.first;
        return AlertDialog(
            title: const Text('Add New Friend'),
            content: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        AvatarDropdownTile(
                            icon: Icons.person,
                            label: 'Your Avatar',
                            value: selectedAvatar,
                            avatarImages: avatarImages,
                            onChanged: (newAvatar) {
                                setState(() {
                                        selectedAvatar = newAvatar!;
                                    });
                            }
                        ),
                        EditableTile(
                            icon: Icons.edit,
                            label: chosenName,
                            onEdit: () => showEditDialog(
                                context,
                                title: 'Change Name',
                                initialValue: chosenName,
                                onSave: (newName) {
                                    setState(() {
                                            chosenName = newName;
                                        });
                                }
                            )
                        ),
                        DropdownTile(
                            icon: Icons.family_restroom,
                            label: 'Relation',
                            value: chosenRelation,
                            items: RelationNames.dropdownItems,
                            onChanged: (newRelation) {
                                setState(() {
                                        chosenRelation = newRelation!;
                                    });
                            }
                        )
                    ]
                )
            ),
            actions: [
                TextButton(
                    onPressed: () {
                        if (chosenName.isNotEmpty && selectedAvatar.isNotEmpty && chosenRelation.isNotEmpty) {
                            final newFriend = Friend(
                                id: '',
                                name: chosenName,
                                relation: chosenRelation,
                                avatar: selectedAvatar
                            );
                            Provider.of<FriendsProvider>(context, listen: false).addFriend(newFriend);
                            Navigator.of(context).pop();
                        } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill in all fields.'))
                            );
                        }
                    },
                    child: const Text('Add Friend')
                ),
                TextButton(
                    onPressed: () {
                        Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')
                )
            ]
        );
    }
}
