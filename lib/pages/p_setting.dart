// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../statecontrol/controller.dart';
import '../utils/file_handler.dart';
import 'p_subscription.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final Controller c = Get.find();

  // TextStyle tStyle = const TextStyle(color: c.themeColors[c.themeColorIndex.value], fontSize: 17);

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
                        FileHandler().saveData();
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
                        FileHandler().saveData();
                      },
                    ),
                  ),
                ),
//------------------------------ 2 ------------------------------
                ListTile(
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Become Premium'),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.star_rate_rounded,
                        size: 25,
                        color: c.themeColors[c.themeColorIndex.value],
                      ),
                    ],
                  ),
                  onTap: () => c.goToPage(context, SubscriptionPage()),
                ),
//------------------------------ 3 ------------------------------
                ExpansionTile(
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Themes'),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.star_rate_rounded,
                        size: 25,
                        color: c.themeColors[c.themeColorIndex.value],
                      ),
                    ],
                  ),
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
                                FileHandler().saveData();
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
          Obx(
            () => Center(
              child: Text('Beta Version\n Premium: ${c.isPremium.value}'),
            ),
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
