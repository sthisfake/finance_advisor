import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: TextStyle(fontSize:22,fontWeight: FontWeight.w700)),
            SizedBox(height:12),
            ListTile(title: Text('Dark mode'), trailing: Switch(value: true, onChanged: (v){})),
            ListTile(title: Text('Notifications'), trailing: Switch(value: true, onChanged: (v){})),
            SizedBox(height:12),
            Text('About'),
            SizedBox(height:8),
            Text('MVP Finance Advisor – built with love.')
          ],
        ),
      ),
    );
  }
}
