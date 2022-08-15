// ignore_for_file: deprecated_member_use

import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../statecontrol/controller.dart';

class PurchaseApi {
  final Controller c = Get.find();
  static const _apiKey = 'goog_rYnmVZFoKWxoUYAyQaHzkMYEMZQ';

  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(_apiKey);
  }

  static Future<List<Offering>> fetchOffers() async {
    final offerings = await Purchases.getOfferings();
    final current = offerings.current;

    return current == null ? [] : [current];
  }

  void makePurchase(Package package) async {
    try {
      await Purchases.purchasePackage(package);
    } catch (_) {}
    getPurchasesStatus();
  }

  void getPurchasesStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();

      if (customerInfo.entitlements.active.isNotEmpty) {
        c.isPremium.value = true;
      } else {
        c.isPremium.value = false;
      }

      // print('isPremium: ${c.isPremium.value}');
    } catch (_) {}
  }
}
