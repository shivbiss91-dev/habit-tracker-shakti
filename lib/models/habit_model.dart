class HabitModel {
  final String id;
  final String title;
  final String category;
  final String targetFrequency;
  int currentStreak;
  int bestStreak;
  int totalXp;
  final String? visionImagePath;
  final bool smartAlertGym;
  final bool smartAlertIdle;
  final DateTime createdAt;

  HabitModel({
    required this.id,
    required this.title,
    required this.category,
    this.targetFrequency = 'Daily',
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.totalXp = 0,
    this.visionImagePath,
    this.smartAlertGym = false,
    this.smartAlertIdle = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'targetFrequency': targetFrequency,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'totalXp': totalXp,
      'visionImagePath': visionImagePath,
      'smartAlertGym': smartAlertGym,
      'smartAlertIdle': smartAlertIdle,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory HabitModel.fromMap(Map<dynamic, dynamic> map) {
    return HabitModel(
      id: map['id'] as String,
      title: map['title'] as String,
      category: map['category'] as String,
      targetFrequency: (map['targetFrequency'] as String?) ?? 'Daily',
      currentStreak: (map['currentStreak'] as int?) ?? 0,
      bestStreak: (map['bestStreak'] as int?) ?? 0,
      totalXp: (map['totalXp'] as int?) ?? 0,
      visionImagePath: map['visionImagePath'] as String?,
      smartAlertGym: (map['smartAlertGym'] as bool?) ?? false,
      smartAlertIdle: (map['smartAlertIdle'] as bool?) ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
