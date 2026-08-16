import '../models/user_profile_model.dart';
import '../models/habit_model.dart';

class GamificationResult {
  final int xpGained;
  final bool didLevelUp;
  final int newLevel;
  final String? unlockedBadgeTitle;

  GamificationResult({
    required this.xpGained,
    required this.didLevelUp,
    required this.newLevel,
    this.unlockedBadgeTitle,
  });
}

class GamificationService {
  static const int xpPerHabitCompletion = 150;
  static const int xpStreakBonus = 50;

  static GamificationResult processHabitCompletion({
    required HabitModel habit,
    required UserProfileModel profile,
    required bool isNowCompleted,
  }) {
    if (isNowCompleted) {
      habit.currentStreak += 1;
      if (habit.currentStreak > habit.bestStreak) {
        habit.bestStreak = habit.currentStreak;
      }
      final xpGained = xpPerHabitCompletion + (habit.currentStreak > 3 ? xpStreakBonus : 0);
      habit.totalXp += xpGained;

      profile.currentXp += xpGained;
      bool didLevelUp = false;

      while (profile.currentXp >= profile.xpToNextLevel) {
        profile.level += 1;
        profile.xpToNextLevel = (profile.xpToNextLevel * 1.25).round();
        didLevelUp = true;
      }

      String? badge;
      if (habit.currentStreak == 5) {
        badge = "Streak Master ⚡";
      } else if (habit.currentStreak == 10) {
        badge = "Morning Warrior 🏆";
      }

      return GamificationResult(
        xpGained: xpGained,
        didLevelUp: didLevelUp,
        newLevel: profile.level,
        unlockedBadgeTitle: badge,
      );
    } else {
      if (habit.currentStreak > 0) {
        habit.currentStreak -= 1;
      }
      final xpSubtracted = xpPerHabitCompletion;
      if (profile.currentXp >= xpSubtracted) {
        profile.currentXp -= xpSubtracted;
      }
      return GamificationResult(
        xpGained: -xpSubtracted,
        didLevelUp: false,
        newLevel: profile.level,
      );
    }
  }
}
