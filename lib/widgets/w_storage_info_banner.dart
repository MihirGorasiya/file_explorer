import 'package:flutter/material.dart';

class StorageInfoBanner extends StatelessWidget {
  const StorageInfoBanner({
    Key? key,
    required this.usedSpace,
    required this.usedSpacePer,
    required this.totalSpace,
  }) : super(key: key);

  final double? usedSpace;
  final double? usedSpacePer;
  final double? totalSpace;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(25),
      ),
      height: 150,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .35,
            decoration: BoxDecoration(
              // color: Colors.pinkAccent,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Align(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .20,
                height: MediaQuery.of(context).size.width * .20,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                        child: Text(
                      usedSpace == 0
                          ? '85%'
                          : '${(usedSpacePer! * 100).ceil()}%',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    )),
                    CircularProgressIndicator(
                      value: usedSpace == 0 ? 0.75 : usedSpacePer!,
                      color: Colors.grey[700],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.green,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Internal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    'Storage',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    usedSpace == 0
                        ? '00.0 GB/00.0 GB'
                        : '${usedSpace}GB/${totalSpace}GB used',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
