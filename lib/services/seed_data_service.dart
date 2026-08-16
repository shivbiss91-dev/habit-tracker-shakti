import 'dart:math';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/habit_model.dart';
import '../models/daily_log_model.dart';
import '../models/user_profile_model.dart';
import '../models/achievement_model.dart';
import 'hive_service.dart';

class SeedDataService {
  static final _uuid = const Uuid();

  static Future<void> seedIfNecessary() async {
    final existingHabits = HiveService.getAllHabits();
    if (existingHabits.isNotEmpty) return;

    // 1. Seed Default Habits (Exact list from prompt)
    final defaultHabits = [
      HabitModel(
        id: 'h1',
        title: 'Read 15 pages',
        category: 'Mindset',
        currentStreak: 12,
        bestStreak: 18,
        totalXp: 1800,
        smartAlertIdle: true,
      ),
      HabitModel(
        id: 'h2',
        title: 'Gym Workout',
        category: 'Health',
        currentStreak: 8,
        bestStreak: 14,
        totalXp: 1400,
        smartAlertGym: true,
      ),
      HabitModel(
        id: 'h3',
        title: 'No Phone in Bed',
        category: 'Lifestyle',
        currentStreak: 15,
        bestStreak: 20,
        totalXp: 2100,
      ),
      HabitModel(
        id: 'h4',
        title: 'Budget Tracking',
        category: 'Finance',
        currentStreak: 6,
        bestStreak: 10,
        totalXp: 900,
      ),
      HabitModel(
        id: 'h5',
        title: 'Social Media Detox',
        category: 'Productivity',
        currentStreak: 9,
        bestStreak: 12,
        totalXp: 1350,
      ),
      HabitModel(
        id: 'h6',
        title: 'Goal Journaling',
        category: 'Mindset',
        currentStreak: 14,
        bestStreak: 21,
        totalXp: 1950,
      ),
      HabitModel(
        id: 'h7',
        title: 'Cold Shower',
        category: 'Health',
        currentStreak: 7,
        bestStreak: 11,
        totalXp: 1050,
      ),
    ];

    for (var habit in defaultHabits) {
      await HiveService.saveHabit(habit);
    }

    // 2. Seed 30 Days of Historical Logs for Insights Charts & Heatmaps
    final now = DateTime.now();
    final random = Random(42); // Consistent seed for beautiful charts

    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateIso = DateFormat('yyyy-MM-dd').format(date);

      for (var habit in defaultHabits) {
        // High completion rate for realistic data (~85% complete)
        final isCompleted = i == 0 ? (habit.id == 'h1' || habit.id == 'h2' || habit.id == 'h3' || habit.id == 'h6') : random.nextDouble() > 0.18;
        
        // Correlated sleep quality and focus level curves
        final baseSleep = 6.5 + (sin(i / 3.0) * 1.5) + (random.nextDouble() * 1.2);
        final sleepQuality = baseSleep.clamp(5.0, 9.8);
        final focusScore = (sleepQuality * 0.95 + (random.nextDouble() * 1.0)).clamp(4.5, 9.9);

        final log = DailyLogModel(
          id: _uuid.v4(),
          habitId: habit.id,
          dateIso: dateIso,
          isCompleted: isCompleted,
          xpEarned: isCompleted ? 150 : 0,
          focusScore: double.parse(focusScore.toStringAsFixed(1)),
          sleepQuality: double.parse(sleepQuality.toStringAsFixed(1)),
        );

        await HiveService.saveDailyLog(log);
      }
    }

    // 3. Seed User Profile (Level 14 as per prompt)
    final profile = UserProfileModel(
      userName: 'User',
      level: 14,
      currentXp: 4850,
      xpToNextLevel: 5000,
      rankTitle: 'Focus Grandmaster',
      goalOfTheDay: 'Read 15 pages of deep wisdom & complete Gym Workout early.',
      predictionScore: 0.92,
    );
    await HiveService.saveUserProfile(profile);

    // 4. Seed Badges & Achievements
    final achievements = [
      AchievementModel(
        id: 'a1',
        title: 'Morning Warrior',
        description: 'Complete morning habits 10 days in a row',
        iconName: 'trophy',
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 2)),
        category: 'Streak',
      ),
      AchievementModel(
        id: 'a2',
        title: 'Consistency King',
        description: 'Achieve 90%+ habit completion rate over a month',
        iconName: 'crown',
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 5)),
        category: 'Consistency',
      ),
      AchievementModel(
        id: 'a3',
        title: 'Deep Focus Master',
        description: 'Log 50 hours of uninterrupted deep work',
        iconName: 'brain',
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 10)),
        category: 'Focus',
      ),
      AchievementModel(
        id: 'a4',
        title: 'Iron Will',
        description: 'Take cold showers for 30 consecutive days',
        iconName: 'snowflake',
        isUnlocked: false,
        category: 'Health',
      ),
      AchievementModel(
        id: 'a5',
        title: 'Financial Nomad',
        description: 'Track expenses for 60 consecutive days',
        iconName: 'wallet',
        isUnlocked: false,
        category: 'Finance',
      ),
      AchievementModel(
        id: 'a6',
        title: 'Digital Monk',
        description: 'Complete 14 days of social media detox',
        iconName: 'phone_off',
        isUnlocked: false,
        category: 'Lifestyle',
      ),
    ];

    for (var achievement in achievements) {
      await HiveService.saveAchievement(achievement);
    }
  }
}
