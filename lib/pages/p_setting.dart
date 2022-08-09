// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../statecontrol/controller.dart';
import '../temp/p_iap_test.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final Controller c = Get.find();

  // TextStyle tStyle = const TextStyle(color: c.themeColors[c.themeColorIndex.value], fontSize: 17);

  late SharedPreferences prefs;

  @override
  void initState() {
    getSharedPreference();
    super.initState();
  }

  void getSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setting')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
//------------------------------ 0 ------------------------------
                ListTile(
                  title: Text('Dark Mode'),
                  trailing: Obx(
                    () => CupertinoSwitch(
                      activeColor: c.themeColors[c.themeColorIndex.value],
                      value: c.darkMode.value,
                      onChanged: (v) {
                        c.darkMode.value = v;
                        prefs.setBool('darkMode', v);
                      },
                    ),
                  ),
                ),
//------------------------------ 1 ------------------------------
                ListTile(
                  title: Text('Show Hidden Folder'),
                  trailing: Obx(
                    () => CupertinoSwitch(
                      activeColor: c.themeColors[c.themeColorIndex.value],
                      value: c.showHiddenFiles.value,
                      onChanged: (v) {
                        c.showHiddenFiles.value = v;
                        prefs.setBool('showHiddenFiles', v);
                      },
                    ),
                  ),
                ),
//------------------------------ 2 ------------------------------
                ListTile(
                  title: Text('IAP'),
                  onTap: () => c.goToPage(context, IapPurchaseTestPage()),
                ),
//------------------------------ 3 ------------------------------
                ExpansionTile(
                  title: Text('Themes'),
                  children: [
                    SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: c.themeColors.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                c.themeColorIndex.value = index;
                                prefs.setInt('themeColorIndex', index);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: c.themeColors[index],
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Text('Beta Version'),
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}

// Padding(
// padding: const EdgeInsets.all(20.0),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// 'Upcoming Features',
// style: TextStyle(
// color: c.themeColors[c.themeColorIndex.value],
// fontSize: 25,
// ),
// ),
// Text(
// '- Premium feature with membership \n- Light Mode \n- Custom Color Theme \n- Move File \n- Copy Folder',
// style: tStyle,
// ),
// ],
// ),
// )
