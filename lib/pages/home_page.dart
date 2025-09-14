import 'package:flutter/material.dart';
import '../models/txn.dart';
import '../widgets/balance_card.dart';
import '../widgets/transactions_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good day', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    SizedBox(height: 6),
                    Text('Pouya', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  ],
                ),
                CircleAvatar(child: Icon(Icons.person), backgroundColor: Color(0xFF0F1A2B)),
              ],
            ),
            SizedBox(height: 18),
            BalanceCard(),
            SizedBox(height: 16),
            Expanded(child: TransactionsList()),
          ],
        ),
      ),
    );
  }
}
