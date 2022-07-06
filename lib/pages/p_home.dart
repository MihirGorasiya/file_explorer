// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:disk_space/disk_space.dart';
import 'package:file_manager/pages/p_explorer.dart';
import 'package:file_manager/widgets/w_storage_info_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/w_button_with_image.dart';
import '../widgets/w_storage_list_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? totalSpace = 0;
  double? usedSpace = 0;
  double? cardFreeSpace = 0;
  double? usedSpacePer = 0;

  void getStorageInfo() async {
    totalSpace = ((await DiskSpace.getTotalDiskSpace)! / 1000).ceilToDouble();
    usedSpace = totalSpace! -
        ((await DiskSpace.getFreeDiskSpace)! / 1000).ceilToDouble();
    usedSpacePer = usedSpace! / totalSpace!;
    cardFreeSpace =
        ((await DiskSpace.getFreeDiskSpaceForPath('/storage/453E-10F7'))! /
                1000)
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
                    onPressed: () {},
                  ),
                  ButtonWithImage(
                    buttonIcon: Icons.movie_filter,
                    buttonDesc: "Videos",
                    onPressed: () {},
                  ),
                  ButtonWithImage(
                    buttonIcon: Icons.music_note_rounded,
                    buttonDesc: "Music",
                    onPressed: () {},
                  ),
                  ButtonWithImage(
                    buttonIcon: CupertinoIcons.doc_fill,
                    buttonDesc: "Documents",
                    onPressed: () {},
                  ),
                  ButtonWithImage(
                    buttonIcon: Icons.archive,
                    buttonDesc: "Archive",
                    onPressed: () {},
                  ),
                  ButtonWithImage(
                    buttonIcon: Icons.download_rounded,
                    buttonDesc: "Downloads",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExplorerPage(
                            dirPath: '/storage/emulated/0/download/',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            StorageListTile(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExplorerPage(
                      dirPath: '/storage/emulated/0',
                    ),
                  ),
                );
              },
              storageTitle: 'Internal storage',
              usedSpace: usedSpace,
              totalSpace: totalSpace,
              storageInfo: usedSpace == 0
                  ? '00.0 GB/00.0 GB'
                  : '$usedSpace GB of $totalSpace GB used',
            ),
            StorageListTile(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExplorerPage(
                      dirPath: '/storage/453E-10F7',
                    ),
                  ),
                );
              },
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
