import 'package:flutter/material.dart';
import '../models/txn.dart';
import 'txn_card.dart';

class TransactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: dummyTxns.length,
      separatorBuilder: (_, __) => SizedBox(height: 8),
      itemBuilder: (context, idx) {
        final t = dummyTxns[idx];
        return TxnCard(txn: t);
      },
    );
  }
}
