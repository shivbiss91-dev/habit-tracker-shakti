class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String iconName;
  bool isUnlocked;
  final DateTime? unlockedAt;
  final String category;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    this.isUnlocked = false,
    this.unlockedAt,
    this.category = 'General',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconName': iconName,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'category': category,
    };
  }

  factory AchievementModel.fromMap(Map<dynamic, dynamic> map) {
    return AchievementModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      iconName: map['iconName'] as String,
      isUnlocked: (map['isUnlocked'] as bool?) ?? false,
      unlockedAt: map['unlockedAt'] != null
          ? DateTime.parse(map['unlockedAt'] as String)
          : null,
      category: (map['category'] as String?) ?? 'General',
    );
  }
}
