import 'package:flutter/material.dart';
import '../widgets/bar_chart_sample.dart';
import 'package:fl_chart/fl_chart.dart';
class _DelayedChart extends StatelessWidget {
  final bool expanded;
  final Widget Function() chartBuilder;
  const _DelayedChart({required this.expanded, required this.chartBuilder});

  @override
  Widget build(BuildContext context) {
    return expanded
        ? SizedBox(height: 180, child: chartBuilder())
        : SizedBox(height: 180);
  }
}

class PieChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(value: 40, color: Color(0xFF00E5C6), title: 'هزینه'),
          PieChartSectionData(value: 30, color: Color(0xFF7C4DFF), title: 'درآمد'),
          PieChartSectionData(value: 30, color: Color(0xFFFF5252), title: 'پس‌انداز'),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 32,
      ),
    );
  }
}

class LineChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 10),
              FlSpot(1, 30),
              FlSpot(2, 20),
              FlSpot(3, 40),
              FlSpot(4, 25),
              FlSpot(5, 35),
            ],
            isCurved: true,
            color: Color(0xFF00E5C6),
            barWidth: 4,
            dotData: FlDotData(show: false),
          ),
        ],
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
      ),
    );
  }
}


class ReportsPage extends StatelessWidget {
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
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('گزارش‌ها و نمودارها', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 120), // more space for floating menu
                    child: BeautifulStaticCharts(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Beautiful static charts widget for MVP
class BeautifulStaticCharts extends StatefulWidget {
  @override
  State<BeautifulStaticCharts> createState() => _BeautifulStaticChartsState();
}

class _BeautifulStaticChartsState extends State<BeautifulStaticCharts> {
  Set<int> openCards = {};

  void _handleExpand(int index) {
    setState(() {
      if (openCards.contains(index)) {
        openCards.remove(index);
      } else {
        openCards.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF232A3D);
    return Column(
      children: [
        ExpandableChartCard(
          icon: Icons.bar_chart,
          color: Color(0xFF00E5C6),
          title: 'نمودار درآمد و هزینه ماهانه',
          subtitle: 'درآمد و هزینه ماهانه.',
          chartType: ChartType.bar,
          expanded: openCards.contains(0),
          onExpand: () => _handleExpand(0),
          backgroundColor: cardColor,
        ),
        ExpandableChartCard(
          icon: Icons.pie_chart,
          color: Color(0xFF7C4DFF),
          title: 'نمودار دسته‌بندی‌ها',
          subtitle: 'سهم هر دسته‌بندی.',
          chartType: ChartType.pie,
          expanded: openCards.contains(1),
          onExpand: () => _handleExpand(1),
          backgroundColor: cardColor,
        ),
        ExpandableChartCard(
          icon: Icons.show_chart,
          color: Color(0xFFFF5252),
          title: 'نمودار روند مالی',
          subtitle: 'روند مالی شما.',
          chartType: ChartType.line,
          expanded: openCards.contains(2),
          onExpand: () => _handleExpand(2),
          backgroundColor: cardColor,
        ),
      ],
    );
  }
}

enum ChartType { bar, pie, line }

class ExpandableChartCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final ChartType chartType;
  final bool expanded;
  final VoidCallback onExpand;
  final Color backgroundColor;

  const ExpandableChartCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.chartType,
    required this.expanded,
    required this.onExpand,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0,4))],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 38),
                  SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(color: chartType == ChartType.line ? Colors.white38 : chartType == ChartType.pie ? Colors.white54 : Colors.white70)),
                    ],
                  )),
                  IconButton(
                    icon: Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white, size: 28),
                    onPressed: onExpand,
                  ),
                ],
              ),
            ),
            if (expanded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    key: ValueKey('chart'),
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: _DelayedChart(expanded: expanded, chartBuilder: _buildChart),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    switch (chartType) {
      case ChartType.bar:
        return BarChartSample();
      case ChartType.pie:
  return PieChartSample();
      case ChartType.line:
  return LineChartSample();
    }
  }
}

