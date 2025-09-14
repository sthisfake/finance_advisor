import 'package:flutter/material.dart';

class TinyStat extends StatelessWidget {
  final String label;
  final String value;
  TinyStat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white54)),
        SizedBox(height:6),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
