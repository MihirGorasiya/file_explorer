// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';

import 'package:disk_space/disk_space.dart';
import 'package:file_manager/pages/p_explorer.dart';
import 'package:file_manager/pages/p_filtered_explorer.dart';
import 'package:file_manager/pages/p_search.dart';
import 'package:file_manager/pages/p_setting.dart';
import 'package:file_manager/pages/p_whatsapp.dart';
import 'package:file_manager/widgets/w_storage_info_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
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
  final Controller c = Get.find();
  double totalSpace = 0;
  double usedSpace = 0;
  double cardFreeSpace = 0;
  double? usedSpacePer = 0;

  final LocalAuthentication auth = LocalAuthentication();
  String status = 'authenticate';

  Future<bool> authenticate() async {
    final isAvailable = await auth.canCheckBiometrics;
    if ((!isAvailable)) return false;

    bool authenticationStatus = false;
    try {
      authenticationStatus = await auth.authenticate(
        localizedReason: "Verify it's you to proceed",
        options: AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return authenticationStatus;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Set Fingerprint or face lock to phone to use this feature')));
      return false;
    }
  }

  void getStorageInfo() async {
    totalSpace = ((await DiskSpace.getTotalDiskSpace)! / 1000).ceilToDouble();
    usedSpace = totalSpace -
        ((await DiskSpace.getFreeDiskSpace)! / 1000).ceilToDouble();
    usedSpacePer = usedSpace / totalSpace;

    List<Directory>? externalStorages = await getExternalStorageDirectories();
    if (externalStorages!.length > 1) {
      List<String> sdPathSplit = externalStorages[1].path.split('/');
      c.sdPath = '/storage/${sdPathSplit[2]}';
      cardFreeSpace =
          ((await DiskSpace.getFreeDiskSpaceForPath(c.sdPath))! / 1000)
              .ceilToDouble();
    }

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
    WidgetsFlutterBinding.ensureInitialized();
    getStorageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              c.goToPage(context, SearchPage());
            },
            icon: Icon(CupertinoIcons.search),
          ),
          IconButton(
            onPressed: () {
              c.goToPage(context, SettingPage());
            },
            icon: Icon(CupertinoIcons.settings),
          ),
        ],
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              StorageInfoBanner(
                usedSpace: usedSpace,
                usedSpacePer: usedSpacePer,
                totalSpace: totalSpace,
              ),
//------------------------------ Center big square ------------------------------
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                height: 260,
                decoration: BoxDecoration(
                  color: c.themeColors[c.themeColorIndex.value],
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: c.themeColors[c.themeColorIndex.value]
                          .withOpacity(0.4),
                      spreadRadius: 3,
                      blurRadius: 1.5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
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
                          buttonIcon: Icons.whatsapp_rounded,
                          buttonDesc: "WhatsApp",
                          onPressed: () =>
                              c.goToPage(context, WhatsAppMediaPage()
                                  // FilteredExplorerPage(
                                  //   fileType: 'Apks',
                                  //   // isSelecting: false,
                                  // ),
                                  ),
                        ),
                        ButtonWithImage(
                          buttonIcon: Icons.download_rounded,
                          buttonDesc: "Downloads",
                          onPressed: () {
                            c.currentDirectoryPath.value =
                                '/storage/emulated/0/download';
                            c.goToPage(
                              context,
                              ExplorerPage(
                                // dirPath: '/storage/emulated/0/download',
                                isSelecting: false,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
//------------------------------ Internal Storage ------------------------------
              StorageListTile(
                onPressed: () {
                  c.currentDirectoryPath.value = '/storage/emulated/0';
                  c.goToPage(
                    context,
                    ExplorerPage(
                      // dirPath: '/storage/emulated/0',
                      isSelecting: false,
                    ),
                  );
                },
                storageTitle: 'Internal storage',
                storageInfo: usedSpace == 0
                    ? '00.0 GB/00.0 GB'
                    : '$usedSpace GB of $totalSpace GB used',
              ),
//------------------------------ SD Card Storage ------------------------------
              StorageListTile(
                onPressed: () {
                  c.currentDirectoryPath.value = c.sdPath;
                  c.goToPage(
                    context,
                    ExplorerPage(
                      // dirPath: c.sdPath,
                      isSelecting: false,
                    ),
                  );
                },
                storageTitle: 'SD card',
                storageInfo: cardFreeSpace == 0
                    ? '00.0 GB Free'
                    : '$cardFreeSpace GB Free',
              ),
              // StorageListTile(
              //   onPressed: () async {
              //     if (await authenticate()) {
              //       c.goToPage(context, PrivateVaultPage());
              //     }
              //   },
              //   storageTitle: 'Private Vault',
              //   storageInfo: '',
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
