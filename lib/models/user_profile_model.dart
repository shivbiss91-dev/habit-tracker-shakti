class UserProfileModel {
  final String userName;
  final String avatarUrl;
  int level;
  int currentXp;
  int xpToNextLevel;
  String rankTitle;
  String goalOfTheDay;
  double predictionScore;

  UserProfileModel({
    this.userName = 'User',
    this.avatarUrl = 'assets/avatar.png',
    this.level = 14,
    this.currentXp = 4850,
    this.xpToNextLevel = 5000,
    this.rankTitle = 'Focus Grandmaster',
    this.goalOfTheDay = 'Read 15 pages of deep wisdom & workout for 45 mins.',
    this.predictionScore = 0.92,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'avatarUrl': avatarUrl,
      'level': level,
      'currentXp': currentXp,
      'xpToNextLevel': xpToNextLevel,
      'rankTitle': rankTitle,
      'goalOfTheDay': goalOfTheDay,
      'predictionScore': predictionScore,
    };
  }

  factory UserProfileModel.fromMap(Map<dynamic, dynamic> map) {
    return UserProfileModel(
      userName: (map['userName'] as String?) ?? 'User',
      avatarUrl: (map['avatarUrl'] as String?) ?? 'assets/avatar.png',
      level: (map['level'] as int?) ?? 14,
      currentXp: (map['currentXp'] as int?) ?? 4850,
      xpToNextLevel: (map['xpToNextLevel'] as int?) ?? 5000,
      rankTitle: (map['rankTitle'] as String?) ?? 'Focus Grandmaster',
      goalOfTheDay: (map['goalOfTheDay'] as String?) ?? 'Read 15 pages of deep wisdom & workout for 45 mins.',
      predictionScore: (map['predictionScore'] as num?)?.toDouble() ?? 0.92,
    );
  }
}
