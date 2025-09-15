
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../models/txn.dart';
import 'package:intl/intl.dart';
import 'all_transactions_page.dart';

// FlippableStatCard widget
class FlippableStatCard extends StatefulWidget {
	final Gradient gradient;
	final IconData icon;
	final String label;
	final double value;
	final Color valueColor;
	final TextStyle textStyle;
	final TextStyle valueStyle;

	const FlippableStatCard({
		required this.gradient,
		required this.icon,
		required this.label,
		required this.value,
		required this.valueColor,
		required this.textStyle,
		required this.valueStyle,
		Key? key,
	}) : super(key: key);

	@override
	State<FlippableStatCard> createState() => _FlippableStatCardState();
}

class _FlippableStatCardState extends State<FlippableStatCard>
    with SingleTickerProviderStateMixin {
  bool showBack = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    setState(() {
      showBack = !showBack;
      if (showBack) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isFront = _animation.value < 0.5;
          final angle = _animation.value * 3.1416;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: Container(
              width: 120,
              height: 140,
              child: isFront
                  ? _buildFront()
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(3.1416),
                      child: _buildBack(),
                    ),
            ),
          );
        },
      ),
    );
  }

  // 👇 Now these are inside the State class
  Widget _buildFront() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6))
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.valueColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(12),
            child: Icon(widget.icon, color: widget.valueColor, size: 32),
          ),
          SizedBox(height: 10),
          Text(widget.label, style: widget.textStyle),
        ],
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              NumberFormat.decimalPattern('fa').format(widget.value),
              style: widget.valueStyle.copyWith(
                color: widget.valueColor,
                fontSize: 26,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6),
            Text(
              'تومان',
              style: TextStyle(
                fontSize: 14,
                color: widget.valueColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
// StatBoxes widget
class StatBoxes extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		final totalIn = dummyTxns.where((t) => t.income).fold(0.0, (p, e) => p + e.amount);
		final totalOut = dummyTxns.where((t) => !t.income).fold(0.0, (p, e) => p + e.amount);
		final balance = totalIn + totalOut;
		final saving = totalIn * 0.25; // Example: 25% of income as saving
		final spent = totalOut;
		final cardGradients = [
			LinearGradient(colors: [Color(0xFF00BFAE), Color.fromARGB(255, 10, 59, 55)]),
			LinearGradient(colors: [Color(0xFF7C4DFF), Color.fromARGB(255, 36, 18, 85)]),
			LinearGradient(colors: [Color(0xFFFF5252), Color.fromARGB(255, 94, 22, 22)]),
		];
		final icons = [Icons.account_balance_wallet, Icons.savings, Icons.trending_down];
		final labels = ['موجودی', 'پس‌انداز', 'خرج شده'];
		final values = [balance, saving, spent];
		final valueColors = [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)];
		final textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: const Color.fromARGB(221, 255, 255, 255));
		final valueStyle = TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black87);
		return Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: List.generate(3, (i) => Expanded(
				child: Padding(
					padding: EdgeInsets.symmetric(horizontal: 4),
					child: FlippableStatCard(
           
						gradient: cardGradients[i],
						icon: icons[i],
						label: labels[i],
						value: values[i],
						valueColor: valueColors[i],
						textStyle: textStyle,
						valueStyle: valueStyle,
					),
				),
			)),
		);
	}
}

// HomePage and _HomePageState
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
							onChanged: (v) {
								if (v != null) setState(() => _period = v);
							},
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
										setState(() {
											_showAllTxns = true;
										});
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
							onChanged: (v) {
								if (v != null) setState(() => _period = v);
							},
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






