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
                  const SnackBar(
                    backgroundColor: Colors.amber,
                    content: Padding(
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

            c.isTransfering.value = true;
            Navigator.pop(context);
            c.goToPage(
              context,
              const PastePage(),
            );
            break;
          // case 2:
          //   // TODO: Add Move code Here
          //   break;

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
                    Text(
                        '${c.sizeDetails.value.toString().substring(0, 5)} GB'),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
            break;
          default:
        }
        // if (item == 0) {
        //   c.createErrorMessage.value = '';
        //   textController.text = 'New Folder';
        //   showDialog(
        //     context: context,
        //     builder: (context) => Obx(
        //       () => AlertDialog(
        //         contentPadding:
        //             const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        //         title: const Text("Create new folder"),
        //         content: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             TextField(
        //               autofocus: true,
        //               decoration: const InputDecoration(
        //                 hintText: "Enter Folder Name",
        //               ),
        //               controller: textController,
        //             ),
        //             SizedBox(
        //               height: 25,
        //               child: Text(
        //                 c.createErrorMessage.value,
        //                 style: const TextStyle(color: Colors.red),
        //               ),
        //             ),
        //           ],
        //         ),
        //         actions: [
        //           PlainTextButton(
        //             onPressed: onCancelPressed,
        //             text: "Cancel",
        //             textColor: Colors.amber,
        //             bgColor: Colors.grey[900],
        //           ),
        //           PlainTextButton(
        //             onPressed: onCreatePressed,
        //             text: "Create",
        //             bgColor: Colors.amber,
        //             textColor: Colors.grey[900],
        //           ),
        //         ],
        //       ),
        //     ),
        //   );
        // }
      },
      itemBuilder: (BuildContext context) => isSelecting
          ? <PopupMenuEntry>[
              const PopupMenuItem(
                value: 1,
                child: Text('Copy (File Only)'),
              ),
              // const PopupMenuItem(
              //   value: 2,
              //   child: Text('Move'),
              // ),
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
          textColor: Colors.amber,
          bgColor: Colors.grey[900],
        ),
        PlainTextButton(
          onPressed: actionCallBack,
          text: actionText,
          bgColor: Colors.amber,
          textColor: Colors.grey[900],
        ),
      ],
    );
  }
}
