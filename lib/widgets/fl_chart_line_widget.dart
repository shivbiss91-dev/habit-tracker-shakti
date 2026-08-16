import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../providers/insights_provider.dart';

class FlChartLineWidget extends StatelessWidget {
  final List<DailyMetricPoint> metrics;

  const FlChartLineWidget({Key? key, required this.metrics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text("No analytics data available")),
      );
    }

    final consistencySpots = metrics
        .map((m) => FlSpot(m.dayIndex.toDouble(), m.consistencyPercent))
        .toList();
    final sleepSpots = metrics
        .map((m) => FlSpot(m.dayIndex.toDouble(), m.sleepQuality))
        .toList();
    final focusSpots = metrics
        .map((m) => FlSpot(m.dayIndex.toDouble(), m.focusLevel))
        .toList();

    return Column(
      children: [
        // Legend Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildLegendItem("Consistency", AppColors.chartGold),
            _buildLegendItem("Sleep Quality", AppColors.chartBronze),
            _buildLegendItem("Focus Level", AppColors.chartAmber),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 2,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: AppColors.cardBorder,
                  strokeWidth: 0.8,
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 2,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      );
                    },
                    reservedSize: 28,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        'Day ${value.toInt()}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      );
                    },
                    reservedSize: 22,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: AppColors.cardBorder),
              ),
              minX: 1,
              maxX: 30,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                // Consistency line
                LineChartBarData(
                  spots: consistencySpots,
                  isCurved: true,
                  color: AppColors.chartGold,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      radius: 3,
                      color: AppColors.gold,
                      strokeWidth: 1,
                      strokeColor: Colors.black,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.gold.withOpacity(0.08),
                  ),
                ),
                // Sleep Quality line
                LineChartBarData(
                  spots: sleepSpots,
                  isCurved: true,
                  color: AppColors.chartBronze,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                ),
                // Focus Level line
                LineChartBarData(
                  spots: focusSpots,
                  isCurved: true,
                  color: AppColors.chartAmber,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
