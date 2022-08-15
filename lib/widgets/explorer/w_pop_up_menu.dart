import 'dart:io';

import 'package:file_manager/pages/p_paste_page.dart';
import 'package:file_manager/widgets/explorer/w_plain_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../statecontrol/controller.dart';

class PopUpMenu extends StatelessWidget {
  const PopUpMenu({
    Key? key,
    required this.textController,
    required this.onCreatePressed,
    required this.errorMsg,
    required this.isSelecting,
    required this.onDeletePressed,
    required this.onRenamePressed,
  }) : super(key: key);

  final TextEditingController textController;
  final String errorMsg;
  final bool isSelecting;
  final VoidCallback onCreatePressed;
  final VoidCallback onRenamePressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();

    void onCancelPressed() {
      Navigator.pop(context);
    }

    return PopupMenuButton(
      onSelected: (item) {
        switch (item) {
          case 0:
            // New Folder
            c.createErrorMessage.value = '';
            textController.text = 'New Folder';
            showDialog(
              context: context,
              builder: (context) => Obx(
                () => MyAlertDialog(
                  titleText: 'Create new folder',
                  textController: textController,
                  c: c,
                  actionText: "Create",
                  actionCallBack: onCreatePressed,
                  onCancelPressed: () => onCancelPressed(),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: "Enter Folder Name",
                        ),
                        controller: textController,
                      ),
                      SizedBox(
                        height: 25,
                        child: Text(
                          c.createErrorMessage.value,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            break;
          case 1:
            // copy
            for (var i = 0; i < c.selectedItem.length; i++) {
              if (Directory(c.selectedItem[i]).existsSync()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: c.themeColors[c.themeColorIndex.value],
                    content: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "Deselect all Folder(s) to continue Operation.",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );

                return;
              }
            }

            c.isTransfering.value = 1;
            Navigator.pop(context);
            c.goToPage(
              context,
              const PastePage(),
            );
            break;
          case 2:
            // Move
            for (var i = 0; i < c.selectedItem.length; i++) {
              if (Directory(c.selectedItem[i]).existsSync()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: c.themeColors[c.themeColorIndex.value],
                    content: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "Deselect all Folder(s) to continue Operation.",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
                return;
              }
            }

            c.isTransfering.value = 2;
            Navigator.pop(context);
            c.goToPage(
              context,
              const PastePage(),
            );

            // c.isTransfering.value = true;

            break;

          case 3:
            // Rename
            showDialog(
              context: context,
              builder: (context) => Obx(
                () => MyAlertDialog(
                  titleText: "Rename",
                  textController: textController,
                  c: c,
                  actionText: "Create",
                  actionCallBack: onRenamePressed,
                  onCancelPressed: () => onCancelPressed(),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: "Enter Folder Name",
                        ),
                        controller: textController,
                      ),
                      SizedBox(
                        height: 25,
                        child: Text(
                          c.createErrorMessage.value,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            break;
          case 4:
            // Delete
            showDialog(
              context: context,
              builder: (context) => MyAlertDialog(
                titleText: 'Delete',
                textController: textController,
                c: c,
                actionText: "Delete",
                actionCallBack: onDeletePressed,
                onCancelPressed: () => onCancelPressed(),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Are you sure to delete selected Item?"),
                    Text(
                      "(All files will be deleted from selected Folder.)",
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            );
            break;
          case 5:
            // Details
            showDialog(
              context: context,
              builder: (context) => MyAlertDialog(
                titleText: 'Details',
                textController: textController,
                c: c,
                actionText: "Ok",
                actionCallBack: () {
                  onCancelPressed();
                  onCancelPressed();
                },
                onCancelPressed: () {
                  onCancelPressed();
                  onCancelPressed();
                },
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    const Text("Size"),
                    Text(c.sizeDetails.value),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
            break;
          case 6:
            //TODO: Add to Private Vault

            // Check if any folder selected
            // rename file extension to sfmpv
            break;
          default:
        }
      },
      itemBuilder: (BuildContext context) => isSelecting
          ? <PopupMenuEntry>[
              const PopupMenuItem(
                value: 1,
                child: Text('Copy'),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text('Move'),
              ),
              PopupMenuItem(
                value: 3,
                enabled: c.selectedItem.length == 1,
                child: const Text('Rename'),
              ),
              const PopupMenuItem(
                value: 4,
                child: Text('Delete'),
              ),
              PopupMenuItem(
                value: 5,
                child: const Text('Details'),
                onTap: () => c.getSizeDetails(),
              ),
              PopupMenuItem(
                value: 6,
                child: const Text('Add to private vault'),
                onTap: () {},
              ),
            ]
          : <PopupMenuEntry>[
              const PopupMenuItem(
                value: 0,
                child: Text('Create New Folder'),
              ),
            ],
    );
  }
}

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({
    Key? key,
    required this.textController,
    required this.c,
    required this.actionCallBack,
    required this.onCancelPressed,
    required this.content,
    required this.actionText,
    required this.titleText,
  }) : super(key: key);

  final TextEditingController textController;
  final Controller c;
  final Widget content;
  final VoidCallback actionCallBack;
  final VoidCallback onCancelPressed;
  final String actionText;
  final String titleText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      title: Text(titleText),
      content: content,
      actions: [
        PlainTextButton(
          onPressed: onCancelPressed,
          text: "Cancel",
          textColor: c.themeColors[c.themeColorIndex.value],
          bgColor: Colors.grey[900],
        ),
        PlainTextButton(
          onPressed: actionCallBack,
          text: actionText,
          bgColor: c.themeColors[c.themeColorIndex.value],
          textColor: Colors.grey[900],
        ),
      ],
    );
  }
}
