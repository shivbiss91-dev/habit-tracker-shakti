import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../core/constants/app_constants.dart';

class HabitItemCard extends StatelessWidget {
  final HabitModel habit;
  final bool isCompleted;
  final VoidCallback onToggle;

  const HabitItemCard({
    Key? key,
    required this.habit,
    required this.isCompleted,
    required this.onToggle,
  }) : super(key: key);

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return Icons.fitness_center_rounded;
      case 'mindset':
        return Icons.auto_stories_rounded;
      case 'finance':
        return Icons.account_balance_wallet_rounded;
      case 'productivity':
        return Icons.timer_rounded;
      case 'lifestyle':
        return Icons.bedtime_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.surface.withOpacity(0.9) : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? AppColors.gold.withOpacity(0.6) : AppColors.cardBorder,
          width: isCompleted ? 1.5 : 1.0,
        ),
        boxShadow: isCompleted
            ? [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.12),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ]
            : [],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.gold.withOpacity(0.2)
                : AppColors.surfaceLight,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted ? AppColors.gold : Colors.transparent,
              width: 1,
            ),
          ),
          child: Icon(
            _getCategoryIcon(habit.category),
            color: isCompleted ? AppColors.gold : AppColors.textSecondary,
            size: 22,
          ),
        ),
        title: Text(
          habit.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isCompleted ? AppColors.textPrimary : AppColors.textPrimary,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            decorationColor: AppColors.gold,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4, right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                habit.category,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            if (habit.currentStreak > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded, size: 14, color: AppColors.gold),
                    Text(
                      '${habit.currentStreak}d streak',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: GestureDetector(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.gold : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isCompleted ? AppColors.goldLight : AppColors.textSecondary,
                width: 2,
              ),
              boxShadow: isCompleted
                  ? [
                      BoxShadow(
                        color: AppColors.gold.withOpacity(0.4),
                        blurRadius: 6,
                      )
                    ]
                  : [],
            ),
            child: isCompleted
                ? const Icon(
                    Icons.check_rounded,
                    color: Colors.black,
                    size: 20,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
