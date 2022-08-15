import 'package:flutter/material.dart';

class PrivateVaultPage extends StatefulWidget {
  const PrivateVaultPage({Key? key}) : super(key: key);

  @override
  State<PrivateVaultPage> createState() => _PrivateVaultPageState();
}

class _PrivateVaultPageState extends State<PrivateVaultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Private Vault'),
      ),
      body: const Center(
        child: Text('Private Vault'),
      ),
    );
  }
}
