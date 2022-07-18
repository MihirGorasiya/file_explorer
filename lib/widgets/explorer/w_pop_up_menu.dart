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
  }) : super(key: key);

  final TextEditingController textController;
  final String errorMsg;
  final bool isSelecting;
  final VoidCallback onCreatePressed;
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
            c.createErrorMessage.value = '';
            textController.text = 'New Folder';
            showDialog(
              context: context,
              builder: (context) => Obx(
                () => MyAlertDialog(
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
            // onDeletePressed;
            showDialog(
              context: context,
              builder: (context) => MyAlertDialog(
                textController: textController,
                c: c,
                actionText: "Delete",
                actionCallBack: onDeletePressed,
                onCancelPressed: () => onCancelPressed(),
                content: const Text("Are you sure to delete selected Item?"),
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
                child: Text('Copy'),
              ),
              // const PopupMenuItem(
              //   value: 2,
              //   child: Text('Move'),
              // ),
              const PopupMenuItem(
                value: 3,
                child: Text('Delete'),
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
  }) : super(key: key);

  final TextEditingController textController;
  final Controller c;
  final Widget content;
  final VoidCallback actionCallBack;
  final VoidCallback onCancelPressed;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      title: const Text("Create new folder"),
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
