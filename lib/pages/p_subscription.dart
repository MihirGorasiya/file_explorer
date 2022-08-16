// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../utils/purchase_api.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  late Set<String> kID = {};

  late List<Package> products = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    List<Offering> offers = await PurchaseApi.fetchOffers();
    products.clear();
    for (var i = 0; i < offers.length; i++) {
      products.addAll(offers[i].availablePackages);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IAP Test'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        PurchaseApi().updateCustomerStatus();
      }),
      body: products.isNotEmpty
          ? ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, i) {
                return ListTile(
                    contentPadding:
                        EdgeInsets.only(bottom: 25, left: 15, right: 15),
                    title: Text(products[i].storeProduct.title),
                    subtitle: Text(products[i].storeProduct.description),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        PurchaseApi().makePurchase(products[i]);
                      },
                      child: Text(products[i].storeProduct.priceString),
                    ));
              },
            )
          : Center(
              child: ElevatedButton(
                onPressed: () {
                  init();
                },
                child: Text('Refresh'),
              ),
            ),
    );
  }
}
