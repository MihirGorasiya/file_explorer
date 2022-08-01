// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../statecontrol/controller.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    TextStyle tStyle = const TextStyle(color: Colors.amber, fontSize: 17);

    return Scaffold(
      appBar: AppBar(title: Text('Setting')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Dark Mode'),
                  trailing: Obx(() => CupertinoSwitch(
                        value: c.darkMode.value,
                        onChanged: (v) {
                          c.darkMode.value = v;
                        },
                      )),
                ),
                ExpansionTile(
                  title: Text('Themes'),
                  children: [
                    SizedBox(
                      height: 100,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, item) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
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
// color: Colors.amber,
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
