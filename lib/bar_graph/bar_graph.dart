import 'package:expenses_tracker/bar_graph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  const MyBarGraph({
    super.key,
    this.maxY,
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
  });

  final double? maxY;
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;

  @override
  Widget build(BuildContext context) {
    // initialized bar data
    BarData myBarData = BarData(
        sunAmount: sunAmount,
        monAmount: monAmount,
        tueAmount: tueAmount,
        wedAmount: wedAmount,
        thuAmount: thuAmount,
        friAmount: friAmount,
        satAmount: satAmount);

    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: maxY,
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitle,
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: myBarData.barData
            .map((data) => BarChartGroupData(x: data.x, barRods: [
                  BarChartRodData(
                      toY: data.y,
                      color: Colors.purple,
                      width: 24,
                      borderRadius: BorderRadius.circular(4),
                      backDrawRodData: BackgroundBarChartRodData(
                          show: true, toY: maxY, color: Colors.purple[50])),
                ]))
            .toList(),
      ),
    );
  }

  Widget getBottomTitle(
    double value,
    TitleMeta meta,
  ) {
    const style = TextStyle(
      color: Colors.purple,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text(
          'Sun',
          style: style,
        );
        break;
      case 1:
        text = const Text(
          'Mon',
          style: style,
        );
        break;
      case 2:
        text = const Text(
          'Tue',
          style: style,
        );
        break;
      case 3:
        text = const Text(
          'Wed',
          style: style,
        );
        break;
      case 4:
        text = const Text(
          'Thu',
          style: style,
        );
        break;
      case 5:
        text = const Text(
          'Fri',
          style: style,
        );
        break;
      case 6:
        text = const Text(
          'Sat',
          style: style,
        );
        break;
      default:
        text = const Text(
          '',
          style: style,
        );
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}
