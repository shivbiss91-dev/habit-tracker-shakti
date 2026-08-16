import 'package:flutter/material.dart';
import '../models/user_profile_model.dart';
import '../models/achievement_model.dart';
import '../services/hive_service.dart';
import '../services/gamification_service.dart';
import '../models/habit_model.dart';

class GamificationProvider extends ChangeNotifier {
  late UserProfileModel _profile;
  List<AchievementModel> _achievements = [];

  UserProfileModel get profile => _profile;
  List<AchievementModel> get achievements => _achievements;

  GamificationProvider() {
    loadData();
  }

  void loadData() {
    _profile = HiveService.getUserProfile();
    _achievements = HiveService.getAllAchievements();
    notifyListeners();
  }

  GamificationResult handleHabitToggle(HabitModel habit, bool isCompleted) {
    final result = GamificationService.processHabitCompletion(
      habit: habit,
      profile: _profile,
      isNowCompleted: isCompleted,
    );

    HiveService.saveUserProfile(_profile);

    if (result.unlockedBadgeTitle != null) {
      // Check if unlocked badge matches any achievement
      for (var ach in _achievements) {
        if (ach.title.contains(result.unlockedBadgeTitle!) || result.unlockedBadgeTitle!.contains(ach.title)) {
          ach.isUnlocked = true;
          HiveService.saveAchievement(ach);
        }
      }
    }

    notifyListeners();
    return result;
  }
}
