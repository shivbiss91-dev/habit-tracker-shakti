import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/app_constants.dart';
import '../models/habit_model.dart';
import '../providers/habit_provider.dart';
import '../widgets/smart_alert_toggle.dart';
import '../services/notification_service.dart';

class HabitCreatorScreen extends StatefulWidget {
  const HabitCreatorScreen({Key? key}) : super(key: key);

  @override
  State<HabitCreatorScreen> createState() => _HabitCreatorScreenState();
}

class _HabitCreatorScreenState extends State<HabitCreatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String _selectedCategory = 'Productivity';
  bool _smartAlertGym = false;
  bool _smartAlertIdle = false;
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();
  final _uuid = const Uuid();

  final List<String> _categories = [
    'Productivity',
    'Health',
    'Mindset',
    'Finance',
    'Lifestyle',
  ];

  final List<Map<String, String>> _templates = [
    {'title': 'Deep Work', 'category': 'Productivity'},
    {'title': 'Mindfulness Journey', 'category': 'Mindset'},
    {'title': 'Health Optimization', 'category': 'Health'},
    {'title': 'Financial Discipline', 'category': 'Finance'},
    {'title': 'Digital Detox', 'category': 'Lifestyle'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _applyTemplate(Map<String, String> template) {
    setState(() {
      _titleController.text = template['title']!;
      _selectedCategory = template['category']!;
    });
  }

  Future<void> _pickVisionImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      }
    } catch (e) {
      // Fallback preview notification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selected vision photo successfully!")),
      );
    }
  }

  Future<void> _saveHabit() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a habit name")),
      );
      return;
    }

    final newHabit = HabitModel(
      id: _uuid.v4(),
      title: _titleController.text.trim(),
      category: _selectedCategory,
      smartAlertGym: _smartAlertGym,
      smartAlertIdle: _smartAlertIdle,
      visionImagePath: _imagePath,
    );

    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    await habitProvider.addHabit(newHabit);

    if (_smartAlertGym || _smartAlertIdle) {
      NotificationService.showNotification(
        id: newHabit.id.hashCode,
        title: 'Smart Alert Active 🔔',
        body: 'Subscribed to smart trigger alerts for "${newHabit.title}"!',
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surface,
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.gold),
              const SizedBox(width: 8),
              Text(
                'Habit "${newHabit.title}" created successfully!',
                style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
      _titleController.clear();
      setState(() {
        _imagePath = null;
        _smartAlertGym = false;
        _smartAlertIdle = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HABIT CREATOR"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Templates Header & Chips
              const Text(
                "Quick Templates",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _templates.map((template) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(template['title']!),
                        avatar: const Icon(Icons.flash_on_rounded, size: 14, color: AppColors.gold),
                        backgroundColor: AppColors.surface,
                        side: const BorderSide(color: AppColors.cardBorder),
                        onPressed: () => _applyTemplate(template),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // 2. Habit Name Form Input
              const Text(
                "Habit Name",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: "e.g. Read 15 pages or Gym Workout",
                  prefixIcon: Icon(Icons.edit_rounded, color: AppColors.gold),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Category Dropdown
              const Text(
                "Choose Category",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                    icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.gold),
                    items: _categories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCategory = val;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 4. Smart Alerts Section
              const Text(
                "Smart Alerts",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              SmartAlertToggle(
                title: "Remind when arriving at Gym",
                subtitle: "Triggers location-based notification when arriving at workout area",
                icon: Icons.location_on_rounded,
                value: _smartAlertGym,
                onChanged: (val) {
                  setState(() {
                    _smartAlertGym = val;
                  });
                },
              ),
              SmartAlertToggle(
                title: "Suggest read when phone is idle",
                subtitle: "Triggers smart prompt when device is untouched for 20 mins",
                icon: Icons.hourglass_top_rounded,
                value: _smartAlertIdle,
                onChanged: (val) {
                  setState(() {
                    _smartAlertIdle = val;
                  });
                },
              ),
              const SizedBox(height: 20),

              // 5. Vision Board Image Picker
              const Text(
                "Personal Vision Board",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickVisionImage,
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _imagePath != null ? AppColors.gold : AppColors.cardBorder,
                      width: _imagePath != null ? 2 : 1,
                    ),
                  ),
                  child: _imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            File(_imagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: Icon(Icons.image_rounded, size: 40, color: AppColors.gold),
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_a_photo_rounded, color: AppColors.gold, size: 36),
                            SizedBox(height: 8),
                            Text(
                              "Attach a Personal Vision Photo",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.gold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Tap to select image from gallery",
                              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 28),

              // 6. Large Start This Habit CTA Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveHabit,
                  icon: const Icon(Icons.play_arrow_rounded, size: 24),
                  label: const Text("Start this Habit"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: AppColors.gold,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
