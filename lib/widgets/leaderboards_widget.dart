import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

class LeaderboardEntry {
  final int rank;
  final String name;
  final int xp;
  final int streak;
  final bool isUser;

  LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.xp,
    required this.streak,
    this.isUser = false,
  });
}

class LeaderboardsWidget extends StatefulWidget {
  const LeaderboardsWidget({Key? key}) : super(key: key);

  @override
  State<LeaderboardsWidget> createState() => _LeaderboardsWidgetState();
}

class _LeaderboardsWidgetState extends State<LeaderboardsWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<LeaderboardEntry> _globalLeaders = [
    LeaderboardEntry(rank: 1, name: 'Aria Vance 👑', xp: 14200, streak: 45),
    LeaderboardEntry(rank: 2, name: 'Marcus Sterling ⚡', xp: 12850, streak: 38),
    LeaderboardEntry(rank: 3, name: 'Elena Rostova 🏆', xp: 11400, streak: 31),
    LeaderboardEntry(rank: 4, name: 'User (You)', xp: 9850, streak: 15, isUser: true),
    LeaderboardEntry(rank: 5, name: 'David Chen', xp: 8900, streak: 22),
    LeaderboardEntry(rank: 6, name: 'Sarah Jenkins', xp: 7650, streak: 19),
  ];

  final List<LeaderboardEntry> _percentileLeaders = [
    LeaderboardEntry(rank: 1, name: 'Top 1% Elite Cohort', xp: 15000, streak: 50),
    LeaderboardEntry(rank: 2, name: 'User (Top 3% Global) ⭐', xp: 9850, streak: 15, isUser: true),
    LeaderboardEntry(rank: 3, name: 'Top 5% Performers', xp: 8500, streak: 20),
    LeaderboardEntry(rank: 4, name: 'Top 10% Focus Guild', xp: 6200, streak: 12),
  ];

  final List<LeaderboardEntry> _friendlyLeaders = [
    LeaderboardEntry(rank: 1, name: 'User (You) 🥇', xp: 9850, streak: 15, isUser: true),
    LeaderboardEntry(rank: 2, name: 'Alex (Friend)', xp: 8100, streak: 12),
    LeaderboardEntry(rank: 3, name: 'Samantha (Friend)', xp: 7400, streak: 9),
    LeaderboardEntry(rank: 4, name: 'Jordan (Friend)', xp: 5900, streak: 6),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar Header
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(10),
            ),
            labelColor: Colors.black,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "Global"),
              Tab(text: "Percentile"),
              Tab(text: "Friendly"),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildLeaderList(_globalLeaders),
              _buildLeaderList(_percentileLeaders),
              _buildLeaderList(_friendlyLeaders),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderList(List<LeaderboardEntry> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final entry = list[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: entry.isUser ? AppColors.gold.withOpacity(0.18) : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: entry.isUser ? AppColors.gold : AppColors.cardBorder,
              width: entry.isUser ? 1.5 : 0.8,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  _getRankBadge(entry.rank),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: entry.rank <= 3 ? AppColors.gold : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  entry.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: entry.isUser ? FontWeight.bold : FontWeight.w500,
                    color: entry.isUser ? AppColors.goldLight : AppColors.textPrimary,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.flash_on_rounded, size: 14, color: AppColors.gold),
                  Text(
                    '${entry.xp} XP',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '🔥 ${entry.streak}d',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _getRankBadge(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '#$rank';
    }
  }
}
