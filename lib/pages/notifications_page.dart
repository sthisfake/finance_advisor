import 'package:flutter/material.dart';
import '../widgets/notification_card.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifications', style: TextStyle(fontSize:22,fontWeight: FontWeight.w700)),
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
