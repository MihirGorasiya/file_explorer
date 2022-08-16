import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../statecontrol/controller.dart';

class PremiumStarWidget extends StatelessWidget {
  const PremiumStarWidget({
    Key? key,
    required this.c,
  }) : super(key: key);

  final Controller c;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Icon(
        Icons.star_rate_rounded,
        size: 25,
        color: c.themeColors[c.themeColorIndex.value],
      ),
    );
  }
}
