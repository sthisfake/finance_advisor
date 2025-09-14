import 'package:flutter/material.dart';
import '../models/txn.dart';
import '../widgets/txn_card.dart';
import 'package:intl/intl.dart';

class AllTransactionsPage extends StatefulWidget {
  @override
  _AllTransactionsPageState createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  String _period = 'ماه جاری';

  List<Txn> get filteredTxns {
    final now = DateTime.now();
    if (_period == 'ماه جاری') {
      return dummyTxns.where((t) => t.date.month == now.month && t.date.year == now.year).toList();
    } else if (_period == 'ماه قبل') {
      final lastMonth = now.month == 1 ? 12 : now.month - 1;
      final year = lastMonth == 12 ? now.year - 1 : now.year;
      return dummyTxns.where((t) => t.date.month == lastMonth && t.date.year == year).toList();
    }
    return dummyTxns;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F1A2B), Color(0xFF232A3D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 8),
                    Text('تراکنش‌ها', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Spacer(),
                    DropdownButton<String>(
                      value: _period,
                      items: ['ماه جاری', 'ماه قبل', 'همه'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                      onChanged: (v) => setState(() => _period = v!),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredTxns.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8),
                    itemBuilder: (context, idx) => TxnCard(txn: filteredTxns[idx]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
