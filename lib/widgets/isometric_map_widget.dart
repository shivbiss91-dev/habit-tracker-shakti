import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

class IsometricMapWidget extends StatelessWidget {
  const IsometricMapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 2,
          )
        ],
      ),
      child: Stack(
        children: [
          // Background Painter
          CustomPaint(
            size: Size.infinite,
            painter: IsometricBoardPainter(),
          ),
          // Interactive Nodes Overlay
          Positioned(
            left: 40,
            bottom: 40,
            child: _buildMapPin("Health Realm", Icons.check_circle_rounded, isUnlocked: true),
          ),
          Positioned(
            left: 130,
            bottom: 110,
            child: _buildMapPin("Focus Sanctuary", Icons.check_circle_rounded, isUnlocked: true),
          ),
          Positioned(
            right: 120,
            top: 70,
            child: _buildMapPin("Mind Citadel", Icons.stars_rounded, isCurrent: true, isUnlocked: true),
          ),
          Positioned(
            right: 40,
            top: 25,
            child: _buildMapPin("Financial Fortress", Icons.lock_rounded, isUnlocked: false),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPin(
    String label,
    IconData icon, {
    bool isUnlocked = false,
    bool isCurrent = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isCurrent
                ? AppColors.gold
                : (isUnlocked ? AppColors.surfaceLight : AppColors.surface),
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrent ? AppColors.goldLight : (isUnlocked ? AppColors.gold : AppColors.textSecondary),
              width: isCurrent ? 3 : 1.5,
            ),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: AppColors.gold.withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 3,
                    )
                  ]
                : [],
          ),
          child: Icon(
            icon,
            size: isCurrent ? 24 : 18,
            color: isCurrent ? Colors.black : (isUnlocked ? AppColors.gold : AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCurrent ? AppColors.gold : AppColors.cardBorder,
              width: 0.8,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
              color: isCurrent ? AppColors.gold : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class IsometricBoardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = AppColors.gold.withOpacity(0.4)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final paintGrid = Paint()
      ..color = AppColors.cardBorder.withOpacity(0.2)
      ..strokeWidth = 1.0;

    // Draw background isometric grid lines
    for (double i = -size.width; i < size.width * 2; i += 40) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height * 1.5, size.height),
        paintGrid,
      );
      canvas.drawLine(
        Offset(i, size.height),
        Offset(i + size.height * 1.5, 0),
        paintGrid,
      );
    }

    // Draw main game path connecting nodes
    final path = Path()
      ..moveTo(60, size.height - 60)
      ..cubicTo(100, size.height - 120, 120, size.height - 100, 150, size.height - 130)
      ..cubicTo(180, size.height - 160, 220, 120, size.width - 140, 95)
      ..lineTo(size.width - 60, 50);

    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
