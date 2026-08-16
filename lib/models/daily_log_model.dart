class DailyLogModel {
  final String id;
  final String habitId;
  final String dateIso; // YYYY-MM-DD
  bool isCompleted;
  int xpEarned;
  double focusScore;
  double sleepQuality;

  DailyLogModel({
    required this.id,
    required this.habitId,
    required this.dateIso,
    this.isCompleted = false,
    this.xpEarned = 0,
    this.focusScore = 8.5,
    this.sleepQuality = 8.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      'dateIso': dateIso,
      'isCompleted': isCompleted,
      'xpEarned': xpEarned,
      'focusScore': focusScore,
      'sleepQuality': sleepQuality,
    };
  }

  factory DailyLogModel.fromMap(Map<dynamic, dynamic> map) {
    return DailyLogModel(
      id: map['id'] as String,
      habitId: map['habitId'] as String,
      dateIso: map['dateIso'] as String,
      isCompleted: (map['isCompleted'] as bool?) ?? false,
      xpEarned: (map['xpEarned'] as int?) ?? 0,
      focusScore: (map['focusScore'] as num?)?.toDouble() ?? 8.0,
      sleepQuality: (map['sleepQuality'] as num?)?.toDouble() ?? 8.0,
    );
  }
}
