// ignore_for_file: avoid_print

import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static const _apiKey = 'goog_rYnmVZFoKWxoUYAyQaHzkMYEMZQ';

  static Future init() async {
    print('object');
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(_apiKey);
    print('object');
  }

  // static Future<List<Offering>> fetchOffers() async {
  //   final offerings = await Purchases.getOfferings();
  //   final current = offerings.current;

  //   return current == null ? [] : [current];
  // }
}
