import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartSample extends StatelessWidget {
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
