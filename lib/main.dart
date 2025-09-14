// Flutter Finance Adviser MVP
// Single-file starter app (main.dart)
// Add to a new Flutter project and replace lib/main.dart with this file.
// PUBSPEC: add these dependencies in pubspec.yaml:
//   fl_chart: ^0.55.2
//   intl: any
//   cupertino_icons: ^1.0.2

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(FinanceAdvisorApp());
}

class FinanceAdvisorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Advisor',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: SplashWrapper(),
    );
  }

  ThemeData _buildTheme() {
    final base = ThemeData.dark();
    return base.copyWith(
      primaryColor: Color(0xFF00E5C6), // mint accent
      scaffoldBackgroundColor: Color(0xFF0B1020), // deep dark
      colorScheme: base.colorScheme.copyWith(secondary: Color(0xFF7C4DFF)),
      textTheme: base.textTheme.apply(fontFamily: 'Inter'),
    );
  }
}

// --- Splash ---
class SplashWrapper extends StatefulWidget {
  @override
  _SplashWrapperState createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> with TickerProviderStateMixin {
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: Duration(milliseconds: 1400));
    _anim.forward();
    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MainShell()));
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF07102A), Color(0xFF081423)]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: CurvedAnimation(parent: _anim, curve: Curves.elasticOut),
              child: _LogoWidget(),
            ),
            SizedBox(height: 24),
            FadeTransition(
              opacity: _anim,
              child: Text('Finance Advisor', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white70)),
            )
          ],
        ),
      ),
    );
  }
}

class _LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [Color(0xFF00E5C6), Color(0xFF7C4DFF)]),
        boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Center(
        child: Icon(Icons.account_balance_wallet_rounded, size: 56, color: Colors.white),
      ),
    );
  }
}

// --- Main Shell with custom floating bottom nav ---
class MainShell extends StatefulWidget {
  @override
  _MainShellState createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with TickerProviderStateMixin {
  int _selectedIndex = 2; // chatbot center by default
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [HomePage(), ReportsPage(), ChatbotPage(), NotificationsPage(), SettingsPage()];
  }

  void _onTap(int idx) {
    setState(() => _selectedIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        child: _pages[_selectedIndex],
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
      ),
      bottomNavigationBar: _FloatingBottomNav(selectedIndex: _selectedIndex, onTap: _onTap),
    );
  }
}

class _FloatingBottomNav extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;
  _FloatingBottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).primaryColor;
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 64),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFF0D1626),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavIcon(icon: Icons.home_rounded, index: 0, selectedIndex: selectedIndex, onTap: onTap),
          _NavIcon(icon: Icons.bar_chart_rounded, index: 1, selectedIndex: selectedIndex, onTap: onTap),

          // center big chatbot button
          GestureDetector(
            onTap: () => onTap(2),
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [accent, Theme.of(context).colorScheme.secondary]),
                boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.secondary.withOpacity(0.32), blurRadius: 18, offset: Offset(0, 8))],
              ),
              child: Icon(Icons.chat_bubble_rounded, size: 36, color: Colors.white),
            ),
          ),

          _NavIcon(icon: Icons.notifications_rounded, index: 3, selectedIndex: selectedIndex, onTap: onTap),
          _NavIcon(icon: Icons.settings_rounded, index: 4, selectedIndex: selectedIndex, onTap: onTap),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final int index;
  final int selectedIndex;
  final void Function(int) onTap;
  _NavIcon({required this.icon, required this.index, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool active = index == selectedIndex;
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(6),
        child: Icon(icon, size: 26, color: active ? Theme.of(context).primaryColor : Colors.white54),
      ),
    );
  }
}

// --- Dummy Data Models ---
class Txn {
  final String title;
  final DateTime date;
  final double amount;
  final bool income;
  final String category;
  Txn({required this.title, required this.date, required this.amount, required this.income, required this.category});
}

final List<Txn> dummyTxns = List.generate(8, (i) {
  final now = DateTime.now();
  final amt = (i + 1) * 12.5;
  return Txn(title: ['Coffee','Grocery','Internet','Salary','Rent','Electric','Dining','Gym'][i], date: now.subtract(Duration(days: i * 2)), amount: amt, income: i==3, category: ['Food','Grocery','Bills','Income','Housing','Bills','Food','Health'][i]);
});

// --- Pages ---
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
            _BalanceCard(),
            SizedBox(height: 16),
            Expanded(child: _TransactionsList()),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final totalIn = dummyTxns.where((t) => t.income).fold(0.0, (p, e) => p + e.amount);
    final totalOut = dummyTxns.where((t) => !t.income).fold(0.0, (p, e) => p + e.amount);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(colors: [Color(0xFF07102A), Color(0xFF081423)]),
        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(0,6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('This month', style: TextStyle(color: Colors.white70)),
              Icon(Icons.more_vert, color: Colors.white24)
            ],
          ),
          SizedBox(height: 12),
          Text('Balance', style: TextStyle(color: Colors.white70)),
          SizedBox(height: 6),
          Text(NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(totalIn - totalOut), style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
          SizedBox(height: 14),
          SizedBox(height: 140, child: _MiniLineChart()),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TinyStat(label: 'Income', value: NumberFormat.compactCurrency(symbol: '\$').format(totalIn)),
              _TinyStat(label: 'Expenses', value: NumberFormat.compactCurrency(symbol: '\$').format(totalOut)),
            ],
          )
        ],
      ),
    );
  }
}

class _TinyStat extends StatelessWidget {
  final String label;
  final String value;
  _TinyStat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(color: Colors.white54)), SizedBox(height:6), Text(value, style: TextStyle(fontWeight: FontWeight.w600))]);
  }
}

class _MiniLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final spots = List.generate(7, (i) => FlSpot(i.toDouble(), (i * 10 + 5).toDouble()));
    return LineChart(LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 80,
      lineBarsData: [LineChartBarData(spots: spots, isCurved: true, barWidth: 3, dotData: FlDotData(show:false))],
    ));
  }
}

class _TransactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: dummyTxns.length,
      separatorBuilder: (_, __) => SizedBox(height: 8),
      itemBuilder: (context, idx) {
        final t = dummyTxns[idx];
        return _TxnCard(txn: t);
      },
    );
  }
}

class _TxnCard extends StatelessWidget {
  final Txn txn;
  _TxnCard({required this.txn});
  @override
  Widget build(BuildContext context) {
    final amt = NumberFormat.currency(symbol: '\$').format(txn.amount);
    return ListTile(
      tileColor: Color(0xFF071426),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: CircleAvatar(child: Icon(txn.income ? Icons.arrow_downward : Icons.arrow_upward), backgroundColor: txn.income ? Colors.green : Colors.deepOrange),
      title: Text(txn.title, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(DateFormat.yMMMd().format(txn.date)),
      trailing: Text(amt, style: TextStyle(fontWeight: FontWeight.w700, color: txn.income ? Colors.greenAccent : Colors.redAccent)),
    );
  }
}

// --- Reports Page ---
class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Reports', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          SizedBox(height: 12),
          Expanded(child: _ReportsContent()),
        ]),
      ),
    );
  }
}

class _ReportsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color(0xFF081428)),
          child: Column(children: [
            Text('Monthly Breakdown', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Expanded(child: _BarChartSample()),
          ]),
        ),
      ),
      SizedBox(height: 12),
      Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color(0xFF081428)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Top categories'), Text('\$${dummyTxns.where((t) => !t.income).fold<double>(0, (p, e) => p + e.amount)
}')]))
    ]);
  }
}

class _BarChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 100,
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(7, (i) => BarChartGroupData(x: i, barRods: [BarChartRodData(toY: (i+1)*12.0, width: 10)])),
    ));
  }
}

// --- Notifications ---
class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Padding(padding: const EdgeInsets.all(18.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Notifications', style: TextStyle(fontSize:22,fontWeight: FontWeight.w700)), SizedBox(height:12), Expanded(child: ListView(children: [ _NotificationCard(title:'Loan due', dueIn:2), _NotificationCard(title:'Electricity bill', dueIn: -1), _NotificationCard(title:'Gym payment', dueIn:6) ]))])));
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final int dueIn; // days, negative = overdue
  _NotificationCard({required this.title, required this.dueIn});
  @override
  Widget build(BuildContext context) {
    Color tagColor = dueIn < 0 ? Colors.redAccent : (dueIn <=3 ? Colors.orangeAccent : Colors.greenAccent);
    return Container(
      margin: EdgeInsets.only(bottom:12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
      color: Color(0xFF071228), 
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontWeight: FontWeight.w600)), SizedBox(height:6), Text(dueIn<0? 'Overdue ${-dueIn}d' : 'Due in ${dueIn}d', style: TextStyle(color: Colors.white54))]),
        Container(padding: EdgeInsets.symmetric(horizontal:12,vertical:8), decoration: BoxDecoration(color: tagColor, borderRadius: BorderRadius.circular(8)), child: Text(dueIn<0? 'Overdue' : 'Upcoming'))
      ]),
    );
  }
}

// --- Settings ---
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Padding(padding: const EdgeInsets.all(18.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Settings', style: TextStyle(fontSize:22,fontWeight: FontWeight.w700)), SizedBox(height:12), ListTile(title: Text('Dark mode'), trailing: Switch(value: true, onChanged: (v){})), ListTile(title: Text('Notifications'), trailing: Switch(value: true, onChanged: (v){})), SizedBox(height:12), Text('About'), SizedBox(height:8), Text('MVP Finance Advisor – built with love.')])));
  }
}

// --- Chatbot Page (button-driven decision tree) ---
class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> with TickerProviderStateMixin {
  final List<_BotMessage> _messages = [];
  late AnimationController _typingCtrl;

  @override
  void initState() {
    super.initState();
    _typingCtrl = AnimationController(vsync: this, duration: Duration(milliseconds: 900));
    _pushBot('Welcome back — how can I help?', options: ['See summary','Add reminder','Categorize txns','Help']);
  }

  @override
  void dispose() {
    _typingCtrl.dispose();
    super.dispose();
  }

  void _pushBot(String text, {List<String>? options}) async {
    setState(() {
      _messages.insert(0, _BotMessage(text: '', options: null, fromBot: true));
    });
    // typing animation
    await Future.delayed(Duration(milliseconds: 350));
    for (int i=0;i<3;i++){
      _typingCtrl.forward(from:0);
      await Future.delayed(Duration(milliseconds: 160));
    }
    setState(() {
      _messages[0] = _BotMessage(text: text, options: options, fromBot: true);
    });
  }

  void _userPick(String label) {
    setState(() => _messages.insert(0, _BotMessage(text: label, options: null, fromBot: false)));

    // handle decision tree quickly
    Future.delayed(Duration(milliseconds: 220), () {
      if (label == 'See summary') {
        final totalIn = dummyTxns.where((t) => t.income).fold(0.0, (p, e) => p + e.amount);
        final totalOut = dummyTxns.where((t) => !t.income).fold(0.0, (p, e) => p + e.amount);
        _pushBot('This month: Income ${NumberFormat.currency(symbol: '\$').format(totalIn)}, Expenses ${NumberFormat.currency(symbol: '\$').format(totalOut)}', options: ['Transactions','Back']);
      } else if (label == 'Add reminder') {
        _pushBot('What type of reminder?', options: ['Loan','Bill','Custom','Back']);
      } else if (label == 'Categorize txns') {
        _pushBot('Pick a transaction to categorize', options: dummyTxns.map((t) => '${t.title} - ${NumberFormat.currency(symbol: '\$').format(t.amount)}').toList()..add('Back'));
      } else if (label == 'Transactions') {
        _pushBot('Recent transactions', options: dummyTxns.map((t) => '${t.title} - ${NumberFormat.currency(symbol: '\$').format(t.amount)}').toList()..add('Back'));
      } else if (label == 'Back') {
        _pushBot('What else can I do?', options: ['See summary','Add reminder','Categorize txns','Help']);
      } else if (label == 'Help') {
        _pushBot('I can show summary, set reminders, and help categorize transactions.', options: ['See summary','Add reminder','Categorize txns','Back']);
      } else if (label.startsWith('Salary') || label.startsWith('Coffee') || label.startsWith('Grocery') || label.startsWith('Internet')) {
        _pushBot('Which category for this transaction?', options: ['Food','Bills','Income','Housing','Other','Back']);
      } else {
        _pushBot('Done ✅', options: ['Back']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [Hero(tag: 'chat-icon', child: Container(width:56,height:56,decoration: BoxDecoration(shape:BoxShape.circle, gradient: LinearGradient(colors:[Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary])), child: Icon(Icons.chat, color: Colors.white))),],),
        SizedBox(height: 12),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: Color(0xFF071428), borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              Expanded(child: _ChatList(messages: _messages)),
              SizedBox(height: 8),
              _QuickReplies(onPick: _userPick, lastBotOptions: _messages.isNotEmpty && _messages.first.fromBot ? _messages.first.options ?? [] : []),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _BotMessage {
  final String text;
  final List<String>? options;
  final bool fromBot;
  _BotMessage({required this.text, required this.options, required this.fromBot});
}

class _ChatList extends StatelessWidget {
  final List<_BotMessage> messages;
  _ChatList({required this.messages});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, idx) {
        final m = messages[idx];
        if (m.fromBot) return _BotBubble(text: m.text, options: m.options);
        return _UserBubble(text: m.text);
      },
    );
  }
}

class _BotBubble extends StatelessWidget {
  final String text;
  final List<String>? options;
  _BotBubble({required this.text, required this.options});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical:8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(child: Icon(Icons.smart_toy_rounded), backgroundColor: Colors.transparent),
        SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF0D1A2B), borderRadius: BorderRadius.circular(12)), child: Text(text, style: TextStyle(color: Colors.white70))),
            if (options != null && options!.isNotEmpty) Wrap(spacing: 8, runSpacing: 6, children: options!.map((o) => _OptionPill(label: o)).toList())
          ]),
        )
      ]),
    );
  }
}

class _OptionPill extends StatelessWidget {
  final String label;
  _OptionPill({required this.label});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // communicate up through ancestor
        final state = context.findAncestorStateOfType<_ChatbotPageState>();
        state?._userPick(label);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal:12, vertical:8),
        decoration: BoxDecoration(color: Color(0xFF0F2236), borderRadius: BorderRadius.circular(999)),
        child: Text(label, style: TextStyle(color: Colors.white70)),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  final String text;
  _UserBubble({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical:8),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(12)), child: Text(text, style: TextStyle(color: Colors.black))),
      ]),
    );
  }
}

class _QuickReplies extends StatelessWidget {
  final void Function(String) onPick;
  final List<String> lastBotOptions;
  _QuickReplies({required this.onPick, required this.lastBotOptions});
  @override
  Widget build(BuildContext context) {
    final options = lastBotOptions.isNotEmpty ? lastBotOptions : ['See summary','Add reminder','Categorize txns','Help'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: options.map((o) => Padding(padding: EdgeInsets.only(right:8), child: InkWell(onTap: ()=>onPick(o), child: Container(padding: EdgeInsets.symmetric(horizontal:14, vertical:10), decoration: BoxDecoration(color: Color(0xFF0F2236), borderRadius: BorderRadius.circular(999)), child: Text(o, style: TextStyle(color: Colors.white70)))))).toList()),
    );
  }
}

// --- End of file ---
