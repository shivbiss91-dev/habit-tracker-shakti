import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit_model.dart';
import '../models/daily_log_model.dart';
import '../models/user_profile_model.dart';
import '../models/achievement_model.dart';

class HiveService {
  static const String habitsBoxName = 'habits_box';
  static const String dailyLogsBoxName = 'daily_logs_box';
  static const String userProfileBoxName = 'user_profile_box';
  static const String achievementsBoxName = 'achievements_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(habitsBoxName);
    await Hive.openBox(dailyLogsBoxName);
    await Hive.openBox(userProfileBoxName);
    await Hive.openBox(achievementsBoxName);
  }

  static Box get habitsBox => Hive.box(habitsBoxName);
  static Box get dailyLogsBox => Hive.box(dailyLogsBoxName);
  static Box get userProfileBox => Hive.box(userProfileBoxName);
  static Box get achievementsBox => Hive.box(achievementsBoxName);

  // Habits Operations
  static List<HabitModel> getAllHabits() {
    final box = habitsBox;
    final List<HabitModel> list = [];
    for (var key in box.keys) {
      final map = box.get(key);
      if (map != null && map is Map) {
        list.add(HabitModel.fromMap(map));
      }
    }
    return list;
  }

  static Future<void> saveHabit(HabitModel habit) async {
    await habitsBox.put(habit.id, habit.toMap());
  }

  static Future<void> deleteHabit(String id) async {
    await habitsBox.delete(id);
  }

  // Daily Logs Operations
  static List<DailyLogModel> getAllDailyLogs() {
    final box = dailyLogsBox;
    final List<DailyLogModel> list = [];
    for (var key in box.keys) {
      final map = box.get(key);
      if (map != null && map is Map) {
        list.add(DailyLogModel.fromMap(map));
      }
    }
    return list;
  }

  static Future<void> saveDailyLog(DailyLogModel log) async {
    await dailyLogsBox.put(log.id, log.toMap());
  }

  // User Profile Operations
  static UserProfileModel getUserProfile() {
    final box = userProfileBox;
    final map = box.get('profile');
    if (map != null && map is Map) {
      return UserProfileModel.fromMap(map);
    }
    return UserProfileModel();
  }

  static Future<void> saveUserProfile(UserProfileModel profile) async {
    await userProfileBox.put('profile', profile.toMap());
  }

  // Achievements Operations
  static List<AchievementModel> getAllAchievements() {
    final box = achievementsBox;
    final List<AchievementModel> list = [];
    for (var key in box.keys) {
      final map = box.get(key);
      if (map != null && map is Map) {
        list.add(AchievementModel.fromMap(map));
      }
    }
    return list;
  }

  static Future<void> saveAchievement(AchievementModel achievement) async {
    await achievementsBox.put(achievement.id, achievement.toMap());
  }
}
