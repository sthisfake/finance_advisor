import 'package:flutter/material.dart';
import '../widgets/notification_card.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 80), // bottom padding for menu
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اعلان‌ها', style: TextStyle(fontSize:22,fontWeight: FontWeight.w700)),
            SizedBox(height:12),
            Expanded(
              child: ListView(children: [
                NotificationCard(title:'Loan due', dueIn:2),
                NotificationCard(title:'Electricity bill', dueIn: -1),
                NotificationCard(title:'Gym payment', dueIn:6)
              ])
            )
          ],
        ),
      ),
    );
  }
}
