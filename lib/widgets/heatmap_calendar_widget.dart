import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../providers/insights_provider.dart';

class HeatmapCalendarWidget extends StatelessWidget {
  final List<DailyMetricPoint> metrics;

  const HeatmapCalendarWidget({Key? key, required this.metrics}) : super(key: key);

  Color _getHeatColor(double score) {
    if (score >= 8.5) return AppColors.gold;
    if (score >= 6.5) return AppColors.bronze;
    if (score >= 4.5) return AppColors.bronzeDark;
    if (score > 0) return AppColors.surfaceLight;
    return const Color(0xFF1E1E1E);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Habit Consistency Matrix (30 Days)",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 1.0,
          ),
          itemCount: 30,
          itemBuilder: (context, index) {
            final metric = index < metrics.length ? metrics[index] : null;
            final score = metric?.consistencyPercent ?? 0.0;
            final color = _getHeatColor(score);

            return Tooltip(
              message: metric != null
                  ? "${metric.dateIso}: ${metric.consistencyPercent * 10}% consistency"
                  : "",
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: score >= 8.5 ? AppColors.goldLight : Colors.transparent,
                    width: 0.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: score >= 6.5 ? Colors.black : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Less ", style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            _buildHeatKey(const Color(0xFF1E1E1E)),
            _buildHeatKey(AppColors.bronzeDark),
            _buildHeatKey(AppColors.bronze),
            _buildHeatKey(AppColors.gold),
            const Text(" More", style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }

  Widget _buildHeatKey(Color color) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
