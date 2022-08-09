// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class IapPurchaseTestPage extends StatefulWidget {
  const IapPurchaseTestPage({Key? key}) : super(key: key);

  @override
  State<IapPurchaseTestPage> createState() => _IapPurchaseTestPageState();
}

class _IapPurchaseTestPageState extends State<IapPurchaseTestPage> {
  String text = 'test';

  @override
  void initState() {
    // PurchaseApi.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IAP Test'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await Purchases.setDebugLogsEnabled(true);
                await Purchases.setup("goog_rYnmVZFoKWxoUYAyQaHzkMYEMZQ");

                try {
                  Offerings offerings = await Purchases.getOfferings();
                  // print('Offers:: ${offerings.current}');
                  if (offerings.current != null) {
                    // print(
                    //     'Offers:: ${offerings.current!.availablePackages[0]}');
                    text =
                        'Offers:: ${offerings.current!.availablePackages[0]}';
                    setState(() {});
                  }
                } catch (e) {
                  text = 'Print:: $e';
                  setState(() {});
                  // print('Print:: $e');
                }
              },
              child: Text('test'),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }
}
