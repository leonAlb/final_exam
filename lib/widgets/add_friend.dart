import 'package:finale_project/widgets/textedit_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/friend.dart';
import '../providers/friends_provider.dart';
import '../utils/static_data.dart';
import '../utils/widget_utils.dart';
import '../widgets/avatar_tile.dart';
import '../widgets/dropdown_tile.dart';

class FriendDialog extends StatefulWidget {
    final Friend? friendToEdit;

    const FriendDialog({super.key, this.friendToEdit});

    @override
    State<FriendDialog> createState() => _FriendDialogState();
}

class _FriendDialogState extends State<FriendDialog> {
    final TextEditingController nameController = TextEditingController();
    final avatarImages = AvatarFilenames.avatars;
    final relationItems = RelationNames.relations;
    String selectedAvatar = AvatarFilenames.avatars.first;
    String chosenRelation = RelationNames.relations.first;

    @override
    void initState() {
        super.initState();
        final friend = widget.friendToEdit;
        if (friend != null) {
            nameController.text = friend.name;
            selectedAvatar = friend.avatar;
            chosenRelation = friend.relation;
        }
    }

    @override
    Widget build(BuildContext context) {
        return AlertDialog(
            title: Text(widget.friendToEdit == null ? 'Add New Friend' : 'Edit Friend'),
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
                            icon: Icons.person,
                            label: nameController.text.isEmpty ? 'Enter Name' : nameController.text,
                            onEdit: () => showEditDialog(
                                context,
                                title: 'Change Name',
                                initialValue: nameController.text,
                                onSave: (newName) {
                                    setState(() {
                                            nameController.text = newName;
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
                // Save action
                TextButton(
                    onPressed: () {
                        if (nameController.text.isNotEmpty && selectedAvatar.isNotEmpty && chosenRelation.isNotEmpty) {
                            final newFriend = Friend(
                                id: widget.friendToEdit?.id ?? '',
                                name: nameController.text,
                                relation: chosenRelation,
                                avatar: selectedAvatar
                            );
                            final provider = Provider.of<FriendsProvider>(context, listen: false);
                            if (widget.friendToEdit == null) {
                                provider.addFriend(newFriend);
                            } else {
                                provider.updateFriend(newFriend);
                            }
                            Navigator.of(context).pop();
                        } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill in all fields.'))
                            );
                        }
                    },
                    child: Text(widget.friendToEdit == null ? 'Add New Friend' : 'Edit Friend')
                ),
                // Cancel action
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
