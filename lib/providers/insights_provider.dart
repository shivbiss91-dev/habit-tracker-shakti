import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/daily_log_model.dart';
import '../services/hive_service.dart';

class DailyMetricPoint {
  final int dayIndex;
  final String dateIso;
  final double consistencyPercent; // 0.0 - 10.0
  final double sleepQuality; // 0.0 - 10.0
  final double focusLevel; // 0.0 - 10.0

  DailyMetricPoint({
    required this.dayIndex,
    required this.dateIso,
    required this.consistencyPercent,
    required this.sleepQuality,
    required this.focusLevel,
  });
}

class InsightsProvider extends ChangeNotifier {
  List<DailyMetricPoint> _30DayMetrics = [];
  double _weeklyPulsePercent = 88.0;
  double _weeklyPulseChange = 12.0;

  List<DailyMetricPoint> get metrics30Days => _30DayMetrics;
  double get weeklyPulsePercent => _weeklyPulsePercent;
  double get weeklyPulseChange => _weeklyPulseChange;

  InsightsProvider() {
    loadData();
  }

  void loadData() {
    final allLogs = HiveService.getAllDailyLogs();
    final allHabits = HiveService.getAllHabits();
    final totalHabitsCount = allHabits.isEmpty ? 1 : allHabits.length;

    final now = DateTime.now();
    final List<DailyMetricPoint> points = [];

    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateIso = DateFormat('yyyy-MM-dd').format(date);

      final dayLogs = allLogs.where((log) => log.dateIso == dateIso).toList();
      final completedLogs = dayLogs.where((log) => log.isCompleted).toList();

      final completionRate = dayLogs.isEmpty
          ? 0.8
          : (completedLogs.length / totalHabitsCount).clamp(0.0, 1.0);

      double avgSleep = 8.0;
      double avgFocus = 8.2;

      if (dayLogs.isNotEmpty) {
        avgSleep = dayLogs.map((l) => l.sleepQuality).reduce((a, b) => a + b) / dayLogs.length;
        avgFocus = dayLogs.map((l) => l.focusScore).reduce((a, b) => a + b) / dayLogs.length;
      }

      points.add(DailyMetricPoint(
        dayIndex: 30 - i,
        dateIso: dateIso,
        consistencyPercent: double.parse((completionRate * 10.0).toStringAsFixed(1)),
        sleepQuality: double.parse(avgSleep.toStringAsFixed(1)),
        focusLevel: double.parse(avgFocus.toStringAsFixed(1)),
      ));
    }

    _30DayMetrics = points;
    notifyListeners();
  }
}
