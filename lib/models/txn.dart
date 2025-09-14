// Transaction model and dummy data
import 'package:intl/intl.dart';

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
  return Txn(
    title: ['Coffee','Grocery','Internet','Salary','Rent','Electric','Dining','Gym'][i],
    date: now.subtract(Duration(days: i * 2)),
    amount: amt,
    income: i==3,
    category: ['Food','Grocery','Bills','Income','Housing','Bills','Food','Health'][i],
  );
});
