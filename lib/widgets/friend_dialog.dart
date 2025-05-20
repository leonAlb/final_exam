import 'package:finale_project/widgets/textedit_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/friend.dart';
import '../providers/friends_provider.dart';
import '../utils/static_data.dart';
import 'dialog_popups.dart';
import '../widgets/avatar_selection_tile.dart';
import '../widgets/dropdown_selection_tile.dart';

class FriendDialog extends StatefulWidget {
    final Friend? friendToEdit;

    const FriendDialog({super.key, this.friendToEdit});

    @override
    State<FriendDialog> createState() => _FriendDialogState();
}

class _FriendDialogState extends State<FriendDialog> {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController mailController = TextEditingController();
    final avatarImages = AvatarFilenames.avatars;
    final relationItems = RelationNames.relations;
    String selectedAvatar = AvatarFilenames.avatars.first;
    String chosenRelation = RelationNames.relations.first;
    bool isHighlighted = false;

    @override
    void initState() {
        super.initState();
        final friend = widget.friendToEdit;
        if (friend != null) {
            selectedAvatar = friend.avatar;
            nameController.text = friend.name;
            chosenRelation = friend.relation;
            mailController.text = friend.email;
            isHighlighted = friend.isHighlighted;
        }
    }

    @override
    Widget build(BuildContext context) {
        final width = MediaQuery.of(context).size.width;
        return Dialog(
            insetPadding: EdgeInsets.all(10),
            child: SizedBox(
                width: width,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            AvatarDropdownTile(
                                label: 'Avatar',
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
                            EditableTile(
                                icon: Icons.email_outlined,
                                label: mailController.text.isEmpty ? 'Enter Email' : mailController.text,
                                onEdit: () => showEditDialog(
                                    context,
                                    title: 'Change Email',
                                    initialValue: mailController.text,
                                    onSave: (newMail) {
                                        setState(() {
                                                mailController.text = newMail;
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
                            ),
                            const SizedBox(height: 20),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('Cancel')
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                            if (nameController.text.isNotEmpty && selectedAvatar.isNotEmpty && chosenRelation.isNotEmpty) {
                                                final newFriend = Friend(
                                                    id: widget.friendToEdit?.id ?? '',
                                                    avatar: selectedAvatar,
                                                    name: nameController.text,
                                                    relation: chosenRelation,
                                                    email: mailController.text,
                                                    isHighlighted: isHighlighted
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
                                    )
                                ]
                            )
                        ]
                    )
                )
            )
        );
    }
}
