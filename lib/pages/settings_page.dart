import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 80), // bottom padding for menu
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تنظیمات', style: TextStyle(fontSize:22,fontWeight: FontWeight.w700)),
            SizedBox(height:12),
            ListTile(title: Text('حالت تاریک'), trailing: Switch(value: true, onChanged: (v){})),
            ListTile(title: Text('اعلان‌ها'), trailing: Switch(value: true, onChanged: (v){})),
            SizedBox(height:12),
            Text('درباره'),
            SizedBox(height:8),
            Text('مشاور مالی نسخه MVP – ساخته شده با عشق.')
          ],
        ),
      ),
    );
  }
}
