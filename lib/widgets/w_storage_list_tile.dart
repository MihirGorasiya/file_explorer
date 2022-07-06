import 'package:flutter/material.dart';

class StorageListTile extends StatelessWidget {
  const StorageListTile({
    Key? key,
    required this.usedSpace,
    this.totalSpace,
    required this.onPressed,
    required this.storageTitle,
    required this.storageInfo,
  }) : super(key: key);

  final double? usedSpace;
  final double? totalSpace;
  final VoidCallback onPressed;
  final String storageTitle;
  final String storageInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 46, 46, 46),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 54, 54, 54),
            spreadRadius: 5,
            blurRadius: 1.5,
          ),
        ],
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storageTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  storageInfo,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
