import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/habit_model.dart';
import '../models/daily_log_model.dart';
import '../services/hive_service.dart';

class HabitProvider extends ChangeNotifier {
  List<HabitModel> _habits = [];
  List<DailyLogModel> _dailyLogs = [];
  DateTime _selectedDate = DateTime.now();
  final _uuid = const Uuid();

  List<HabitModel> get habits => _habits;
  DateTime get selectedDate => _selectedDate;
  String get selectedDateIso => DateFormat('yyyy-MM-dd').format(_selectedDate);

  HabitProvider() {
    loadData();
  }

  void loadData() {
    _habits = HiveService.getAllHabits();
    _dailyLogs = HiveService.getAllDailyLogs();
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  bool isHabitCompletedOnSelectedDate(String habitId) {
    final dateIso = selectedDateIso;
    return _dailyLogs.any((log) => log.habitId == habitId && log.dateIso == dateIso && log.isCompleted);
  }

  double get todayCompletionPercentage {
    if (_habits.isEmpty) return 0.0;
    final completedCount = _habits.where((h) => isHabitCompletedOnSelectedDate(h.id)).length;
    return completedCount / _habits.length;
  }

  Future<bool> toggleHabitCompletion(String habitId) async {
    final dateIso = selectedDateIso;
    final existingIndex = _dailyLogs.indexWhere((log) => log.habitId == habitId && log.dateIso == dateIso);

    bool nowCompleted = true;
    DailyLogModel targetLog;

    if (existingIndex != -1) {
      targetLog = _dailyLogs[existingIndex];
      targetLog.isCompleted = !targetLog.isCompleted;
      nowCompleted = targetLog.isCompleted;
      targetLog.xpEarned = nowCompleted ? 150 : 0;
    } else {
      targetLog = DailyLogModel(
        id: _uuid.v4(),
        habitId: habitId,
        dateIso: dateIso,
        isCompleted: true,
        xpEarned: 150,
      );
      _dailyLogs.add(targetLog);
    }

    await HiveService.saveDailyLog(targetLog);

    // Update Habit streak & stats
    final habitIndex = _habits.indexWhere((h) => h.id == habitId);
    if (habitIndex != -1) {
      final habit = _habits[habitIndex];
      if (nowCompleted) {
        habit.currentStreak += 1;
        if (habit.currentStreak > habit.bestStreak) {
          habit.bestStreak = habit.currentStreak;
        }
        habit.totalXp += 150;
      } else {
        if (habit.currentStreak > 0) habit.currentStreak -= 1;
        if (habit.totalXp >= 150) habit.totalXp -= 150;
      }
      await HiveService.saveHabit(habit);
    }

    notifyListeners();
    return nowCompleted;
  }

  Future<void> addHabit(HabitModel newHabit) async {
    await HiveService.saveHabit(newHabit);
    _habits.add(newHabit);
    notifyListeners();
  }

  Future<void> deleteHabit(String habitId) async {
    await HiveService.deleteHabit(habitId);
    _habits.removeWhere((h) => h.id == habitId);
    notifyListeners();
  }
}
