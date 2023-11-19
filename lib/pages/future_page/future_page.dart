import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  initState() {
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // When you are ready to load your configuration
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Future'),
      ),
      body: Column(
        children: [
          Text('App Pay'),
        ],
      ),
    );
  }
}
