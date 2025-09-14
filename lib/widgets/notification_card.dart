import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final int dueIn; // days, negative = overdue
  NotificationCard({required this.title, required this.dueIn});
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height:6),
              Text(dueIn<0? 'Overdue ${-dueIn}d' : 'Due in ${dueIn}d', style: TextStyle(color: Colors.white54))
            ]
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal:12,vertical:8),
            decoration: BoxDecoration(color: tagColor, borderRadius: BorderRadius.circular(8)),
            child: Text(dueIn<0? 'Overdue' : 'Upcoming')
          )
        ]
      ),
    );
  }
}
