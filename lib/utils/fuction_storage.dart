import 'dart:io';

import 'package:file_manager/statecontrol/controller.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class FuctionStorage {
  final LocalAuthentication auth = LocalAuthentication();
  final Controller c = Get.find();

  Future<bool> authenticate() async {
    final isAvailable = await auth.canCheckBiometrics;
    if ((!isAvailable)) return false;

    bool authenticationStatus = false;
    authenticationStatus = await auth.authenticate(
      localizedReason: 'Scan Fingerprint to Authenticate',
      options: const AuthenticationOptions(
        useErrorDialogs: true,
        stickyAuth: true,
      ),
    );
    return authenticationStatus;
  }

  Future<List<String>> getPrivateFiles() async {
    List<String> allRootDirPathList = [];
    List<String> sdDirs = [];
    List<String> files = [];

    allRootDirPathList = await Directory('/storage/emulated/0')
        .list()
        .map((e) => e.path)
        .toList();

    sdDirs = await Directory(c.sdPath).list().map((e) => e.path).toList();

    allRootDirPathList.addAll(sdDirs);

    int i = 0;
    while (i < allRootDirPathList.length) {
      if (!(allRootDirPathList[i].contains('.') ||
          allRootDirPathList[i].contains('Android'))) {
        files.addAll(await Directory(allRootDirPathList[i])
            .list(recursive: true)
            .map((event) => event.path)
            .where((event) => event.endsWith('.sfmpv'))
            .toList());
      }
      i++;
    }

    //--
    return Future.value(files);
  }
}
