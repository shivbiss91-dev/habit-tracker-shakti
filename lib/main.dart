import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'services/hive_service.dart';
import 'services/seed_data_service.dart';
import 'services/notification_service.dart';
import 'providers/habit_provider.dart';
import 'providers/gamification_provider.dart';
import 'providers/insights_provider.dart';
import 'screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive Offline Database
  await HiveService.init();
  
  // Seed realistic 30-day historical data on first launch
  await SeedDataService.seedIfNecessary();

  // Initialize Notification Manager
  await NotificationService.init();

  runApp(const HabiTrackApp());
}

class HabiTrackApp extends StatelessWidget {
  const HabiTrackApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitProvider()),
        ChangeNotifierProvider(create: (_) => GamificationProvider()),
        ChangeNotifierProvider(create: (_) => InsightsProvider()),
      ],
      child: MaterialApp(
        title: 'HabiTrack - Gamify Your Life',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
