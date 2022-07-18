// ignore_for_file: prefer_const_constructors,prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';

import 'package:file_manager/pages/w_select_icon.dart';
import 'package:file_manager/statecontrol/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/explorer/w_file_icon.dart';
import '../widgets/explorer/w_file_name_widget.dart';
import '../widgets/explorer/w_plain_text.dart';

class PastePage extends StatefulWidget {
  const PastePage({Key? key}) : super(key: key);

  @override
  State<PastePage> createState() => _PastePageState();
}

class _PastePageState extends State<PastePage> {
  final Controller c = Get.find();
  List<String> dirList = [];
  // String dirPath = '/storage/emulated/0';
  String dirPath = '/';
  List<String> storageName = ['Internal Storage', 'SD Card'];
  List<String> storagePath = [];
  bool isCopying = false;

  void getDirList() async {
    dirList = await Directory(dirPath)
        .list()
        .map((e) => e.path)
        .where((element) => !element.contains('.'))
        .toList();
    dirList.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    setState(() {});
  }

  void pasteCopiedFiles() async {
    setState(() {
      isCopying = true;
    });
    //TODO: Function for Directory

    if (dirPath != storagePath[0] &&
        dirPath != storagePath[1] &&
        dirPath != '/') {
      for (var i = 0; i < c.selectedItem.length; i++) {
        if (Directory(c.selectedItem[i]).existsSync()) {
          continue;
        }
        String fileName = c.selectedItem[i].split('/').last;
        await File(c.selectedItem[i]).copy('$dirPath/$fileName');
      }
    }
    c.isTransfering.value = false;
    Navigator.pop(context);
    setState(() {
      isCopying = false;
    });
  }

  @override
  void initState() {
    c.isTransfering.value = true;
    storagePath = ['/storage/emulated/0', c.sdPath];
    super.initState();
  }

  @override
  void dispose() {
    c.isTransfering.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (dirPath != storagePath[0] && dirPath != storagePath[1]) {
          List<String> temp;
          temp = dirPath.split('/');
          temp.removeLast();
          dirPath = temp.join('/');
          getDirList();
        } else if (dirPath != storagePath[0] || dirPath != storagePath[1]) {
          dirPath = '/';
          setState(() {});
        }

        return Future.value(dirPath.isEmpty);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Paste"),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            dirPath != '/'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
//  =========================================== Directory Path Displayer ===========================================
                      SizedBox(
                        height: 23,
                        child: SingleChildScrollView(
                          reverse: true,
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            dirPath,
                          ),
                        ),
                      ),
//  =========================================== Directory List ===========================================
                      Expanded(
                        child: (dirList.isNotEmpty
                            ? ListView.builder(
                                itemCount: dirList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    // color: Colors.grey[800],
                                    child: InkWell(
                                      onTap: () {
                                        dirPath = dirList[index];
                                        getDirList();
                                        setState(() {});
                                      },
                                      onLongPress: () {},
                                      child: Row(
                                        children: [
                                          FileIconWidget(
                                              fileName: dirList[index]),
                                          const SizedBox(width: 10),
                                          FileNameWidget(
                                            isSelecting: false,
                                            fileName:
                                                dirList[index].split('/').last,
                                          ),
                                          const SizedBox(width: 10),
                                          SelectIconWidget(
                                            isSelecting: false,
                                            fileName: dirList[index],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Text('No Child Directory'),
                              )),
                      )
                    ],
                  )
//  =========================================== Storage List ===========================================
                : ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        child: ListTile(
                          tileColor: Colors.grey[800],
                          title: Text(
                            storageName[index],
                            style: const TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 17,
                          ),
                          onTap: () {
                            setState(() {
                              dirPath = storagePath[index];
                              getDirList();
                            });
                          },
                        ),
                      );
                    },
                  ),
            //  =========================================== Paste Button ===========================================
            Positioned(
              bottom: 35,
              width: MediaQuery.of(context).size.width,
              child: Obx(() => Center(
                    child: c.isTransfering.value
                        ? PlainTextButton(
                            onPressed: () => pasteCopiedFiles(),
                            text: "Paste Here",
                            bgColor: Colors.amber,
                            textColor: Colors.grey[900],
                          )
                        : null,
                  )),
            ),
            SizedBox(
              child: isCopying
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.transparent,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 200,
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(
                                height: 20,
                              ),
                              Text('Copying file(s)'),
                            ],
                          ),
                        ),
                      ),
                    )
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
