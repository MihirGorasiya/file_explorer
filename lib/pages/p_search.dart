// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../statecontrol/controller.dart';
import '../widgets/explorer/w_file_icon.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchTextController = TextEditingController();

  final Controller c = Get.find();
  List<String> allRootDirPathList = [];
  List<String> childDirList = [];
  List<String> searchResultList = [];

  void getAllFiles() async {
    allRootDirPathList = await Directory('/storage/emulated/0')
        .list()
        .map((e) => e.path)
        .toList();

    List<String> sdDirs =
        await Directory(c.sdPath).list().map((e) => e.path).toList();

    allRootDirPathList.addAll(sdDirs);

    int i = 0;
    while (i < allRootDirPathList.length) {
      if (!(allRootDirPathList[i].contains('.') ||
          allRootDirPathList[i].contains('Android'))) {
        childDirList.addAll(await Directory(allRootDirPathList[i])
            .list(recursive: true)
            .map((event) => event.path)
            .toList());
      }

      i++;
    }
    setState(() {});
  }

  void searchForString() {
    searchResultList.clear();
    childDirList.forEach((element) {
      if (element.toLowerCase().contains(searchTextController.text)) {
        setState(() {
          searchResultList.add(element);
        });
      }
    });
    // }
  }

  @override
  void initState() {
    getAllFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Page")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: TextField(
              controller: searchTextController,
              textInputAction: TextInputAction.go,
              onEditingComplete: () {
                searchForString();
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    searchForString();
                  },
                  icon: Icon(Icons.search_rounded),
                  color: c.themeColors[c.themeColorIndex.value],
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: ListView.builder(
                itemCount: searchResultList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: FileIconWidget(
                      fileName: searchResultList[index].split('/').last,
                    ),
                    title: Text(searchResultList[index].split('/').last),
                    onTap: () {
                      c.onOpenFile(searchResultList[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
