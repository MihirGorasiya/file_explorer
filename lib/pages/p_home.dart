// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:disk_space/disk_space.dart';
import 'package:file_manager/pages/p_explorer.dart';
import 'package:file_manager/pages/p_filtered_explorer.dart';
import 'package:file_manager/widgets/w_storage_info_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../statecontrol/controller.dart';
import '../widgets/w_button_with_image.dart';
import '../widgets/w_storage_list_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Controller c = Get.put(Controller());
  double? totalSpace = 0;
  double? usedSpace = 0;
  double? cardFreeSpace = 0;
  double? usedSpacePer = 0;
  // String sdPath = '';

  void getStorageInfo() async {
    List<Directory>? externalStorages = await getExternalStorageDirectories();
    List<String> sdPathSplit = externalStorages![1].path.split('/');
    c.sdPath = '/storage/${sdPathSplit[2]}';

    totalSpace = ((await DiskSpace.getTotalDiskSpace)! / 1000).ceilToDouble();
    usedSpace = totalSpace! -
        ((await DiskSpace.getFreeDiskSpace)! / 1000).ceilToDouble();
    usedSpacePer = usedSpace! / totalSpace!;

    cardFreeSpace =
        ((await DiskSpace.getFreeDiskSpaceForPath(c.sdPath))! / 1000)
            .ceilToDouble();
    setState(() {});
  }

  void requestPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.manageExternalStorage.request();
    }
  }

  @override
  void initState() {
    requestPermission();
    getStorageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StorageInfoBanner(
              usedSpace: usedSpace,
              usedSpacePer: usedSpacePer,
              totalSpace: totalSpace,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              height: 260,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.4),
                    spreadRadius: 3,
                    blurRadius: 1.5,
                  ),
                ],
              ),
              child: GridView(
                padding: EdgeInsets.all(15),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ButtonWithImage(
                    buttonIcon: Icons.image,
                    buttonDesc: "Images",
                    onPressed: () => c.goToPage(
                      context,
                      FilteredExplorerPage(
                        fileType: 'Images',
                        // isSelecting: false,
                      ),
                    ),
                  ),
                  ButtonWithImage(
                    buttonIcon: Icons.movie_filter,
                    buttonDesc: "Videos",
                    onPressed: () => c.goToPage(
                      context,
                      FilteredExplorerPage(
                        fileType: 'Videos',
                        // isSelecting: false,
                      ),
                    ),
                  ),
                  ButtonWithImage(
                    buttonIcon: Icons.music_note_rounded,
                    buttonDesc: "Audio",
                    onPressed: () => c.goToPage(
                      context,
                      FilteredExplorerPage(
                        fileType: 'Audios',
                        // isSelecting: false,
                      ),
                    ),
                  ),
                  ButtonWithImage(
                    buttonIcon: CupertinoIcons.doc_fill,
                    buttonDesc: "Documents",
                    onPressed: () => c.goToPage(
                      context,
                      FilteredExplorerPage(
                        fileType: 'Documents',
                        // isSelecting: false,
                      ),
                    ),
                  ),
                  ButtonWithImage(
                    buttonIcon: Icons.archive,
                    buttonDesc: "Apks",
                    onPressed: () => c.goToPage(
                      context,
                      FilteredExplorerPage(
                        fileType: 'Apks',
                        // isSelecting: false,
                      ),
                    ),
                  ),
                  ButtonWithImage(
                    buttonIcon: Icons.download_rounded,
                    buttonDesc: "Downloads",
                    onPressed: () => c.goToPage(
                      context,
                      ExplorerPage(
                        dirPath: '/storage/emulated/0/download',
                        isSelecting: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            StorageListTile(
              onPressed: () => c.goToPage(
                context,
                ExplorerPage(
                  dirPath: '/storage/emulated/0',
                  isSelecting: false,
                ),
              ),
              storageTitle: 'Internal storage',
              usedSpace: usedSpace,
              totalSpace: totalSpace,
              storageInfo: usedSpace == 0
                  ? '00.0 GB/00.0 GB'
                  : '$usedSpace GB of $totalSpace GB used',
            ),
            StorageListTile(
              onPressed: () => c.goToPage(
                context,
                ExplorerPage(
                  dirPath: c.sdPath,
                  isSelecting: false,
                ),
              ),
              storageTitle: 'SD card',
              usedSpace: usedSpace,
              totalSpace: totalSpace,
              storageInfo: cardFreeSpace == 0
                  ? '00.0 GB Free'
                  : '$cardFreeSpace GB Free',
            ),
          ],
        ),
      ),
    );
  }
}
