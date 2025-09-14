import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MiniLineChart extends StatelessWidget {
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
