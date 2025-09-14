
import 'package:flutter/material.dart';
import '../models/txn.dart';
import 'package:intl/intl.dart';
import 'all_transactions_page.dart';

class StatBoxes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final totalIn = dummyTxns.where((t) => t.income).fold(0.0, (p, e) => p + e.amount);
    final totalOut = dummyTxns.where((t) => !t.income).fold(0.0, (p, e) => p + e.amount);
    final balance = totalIn - totalOut;
    final saving = totalIn * 0.25; // Example: 25% of income as saving
    final spent = totalOut;
    final boxStyle = BoxDecoration(
      color: Color(0xFF171C2A),
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0,4))],
    );
    final textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white);
    final valueStyle = TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Color(0xFF00E5C6));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(

          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            decoration: boxStyle,
            child: Column(
              children: [
                Text('موجودی', style: textStyle),
                SizedBox(height: 8),
                Text(NumberFormat.currency(locale: 'fa', symbol: 'تومان', decimalDigits: 0).format(balance), style: valueStyle),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            decoration: boxStyle.copyWith(color: Color(0xFF1B2336)),
            child: Column(
              children: [
                Text('پس‌انداز', style: textStyle),
                SizedBox(height: 8),
                Text(NumberFormat.currency(locale: 'fa', symbol: 'تومان', decimalDigits: 0).format(saving), style: valueStyle.copyWith(color: Color(0xFF7C4DFF))),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            decoration: boxStyle.copyWith(color: Color(0xFF232A3D)),
            child: Column(
              children: [
                Text('خرج شده', style: textStyle),
                SizedBox(height: 8),
                Text(NumberFormat.currency(locale: 'fa', symbol: 'تومان', decimalDigits: 0).format(spent), style: valueStyle.copyWith(color: Color(0xFFFF5252))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showAllTxns = false;
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 80),
          child: _showAllTxns
              ? _buildAllTransactionsView()
              : _buildHomeView(),
        ),
      ),
    );
  }

  Widget _buildHomeView() {
    final lastTxns = filteredTxns.reversed.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('سلام', style: TextStyle(color: Colors.white70, fontSize: 14)),
                SizedBox(height: 6),
                Text('پویا', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              ],
            ),
            CircleAvatar(child: Icon(Icons.person), backgroundColor: Color(0xFF0F1A2B)),
          ],
        ),
        SizedBox(height: 18),
        SizedBox(height: 8),
        StatBoxes(),
        SizedBox(height: 24),
        Row(
          children: [
            Text('تراکنش‌های اخیر', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            Spacer(),
            DropdownButton<String>(
              value: _period,
              items: ['ماه جاری', 'ماه قبل', 'همه'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (v) => setState(() => _period = v!),
            ),
          ],
        ),
        SizedBox(height: 12),
        Column(
          children: [
            for (final t in lastTxns)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  color: Color(0xFF071426),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(t.income ? Icons.arrow_downward : Icons.arrow_upward), backgroundColor: t.income ? Colors.green : Colors.deepOrange),
                    title: Text(t.title, style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(DateFormat.yMMMd('fa').format(t.date)),
                    trailing: Text(NumberFormat.currency(locale: 'fa', symbol: 'تومان', decimalDigits: 0).format(t.amount), style: TextStyle(fontWeight: FontWeight.w700, color: t.income ? Colors.greenAccent : Colors.redAccent)),
                  ),
                ),
              ),
            if (filteredTxns.length > 3)
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => AllTransactionsPage()),
                    );
                  },
                  child: Text('مشاهده همه', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildAllTransactionsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                setState(() {
                  _showAllTxns = false;
                });
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
            itemBuilder: (context, idx) => Card(
              color: Color(0xFF071426),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(child: Icon(filteredTxns[idx].income ? Icons.arrow_downward : Icons.arrow_upward), backgroundColor: filteredTxns[idx].income ? Colors.green : Colors.deepOrange),
                title: Text(filteredTxns[idx].title, style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(DateFormat.yMMMd('fa').format(filteredTxns[idx].date)),
                trailing: Text(NumberFormat.currency(locale: 'fa', symbol: 'تومان', decimalDigits: 0).format(filteredTxns[idx].amount), style: TextStyle(fontWeight: FontWeight.w700, color: filteredTxns[idx].income ? Colors.greenAccent : Colors.redAccent)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}




