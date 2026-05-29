import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_state.dart';
import '../models/models.dart';
import 'quiz_play_screen.dart';

class QuizLevelScreen extends StatelessWidget {
  final QuizCategory category;
  const QuizLevelScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final progress = state.getQuizProgress(category.id);
    final currentLevel = progress?.currentLevel ?? 1;
    final points = progress?.totalPoints ?? 0;
    final accuracy = progress?.accuracy ?? 0;
    final completedLevels = progress?.levelCompletion.values.where((v) => v).length ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.primaryDark,
        title: Text('# KATEGORI',
            style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600, letterSpacing: 1)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category.name,
                style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            const SizedBox(height: 6),
            Text('Uji pengetahuan Anda tentang situs bersejarah, istana, dan bangunan ikonik di Yogyakarta.',
                style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
            const SizedBox(height: 20),
            ...List.generate(category.levels.length, (i) {
              final lvl = category.levels[i];
              final isCompleted = progress?.levelCompletion[lvl.level] ?? false;
              final isAvailable = lvl.level <= currentLevel;
              final isCurrent = lvl.level == currentLevel && !isCompleted;

              return _LevelCard(
                level: lvl,
                isCompleted: isCompleted,
                isAvailable: isAvailable,
                isCurrent: isCurrent,
                onTap: isAvailable ? () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => QuizPlayScreen(
                      questions: lvl.questions.length > 10 ? lvl.questions.take(10).toList() : lvl.questions,
                      title: lvl.title,
                      categoryId: category.id,
                      level: lvl.level,
                    ),
                  ));
                } : null,
              );
            }),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CAPAIAN ANDA',
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.w600, letterSpacing: 1)),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _stat('$points', 'POIN', AppColors.primary),
                      _divider(),
                      _stat('$completedLevels/${category.levels.length}', 'LEVEL', AppColors.accent),
                      _divider(),
                      _stat('$accuracy%', 'AKURASI', AppColors.success),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _stat(String val, String label, Color color) {
    return Column(children: [
      Text(val, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
    ]);
  }

  Widget _divider() => Container(width: 1, height: 40, color: AppColors.divider);
}

class _LevelCard extends StatelessWidget {
  final QuizLevel level;
  final bool isCompleted;
  final bool isAvailable;
  final bool isCurrent;
  final VoidCallback? onTap;

  const _LevelCard({
    required this.level,
    required this.isCompleted,
    required this.isAvailable,
    required this.isCurrent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.white;
    Color borderColor = AppColors.divider;
    Color numBg = AppColors.divider;
    Color numColor = AppColors.textLight;
    Widget? trailing;

    if (isCompleted) {
      bg = Colors.white;
      borderColor = AppColors.divider;
      numBg = AppColors.success.withOpacity(0.1);
      numColor = AppColors.success;
      trailing = const Icon(Icons.check_circle, color: AppColors.success, size: 22);
    } else if (isCurrent) {
      bg = AppColors.primaryDark;
      borderColor = AppColors.primaryDark;
      numBg = AppColors.primary;
      numColor = Colors.white;
      trailing = Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
        child: const Icon(Icons.play_arrow, color: Colors.white, size: 18),
      );
    } else if (!isAvailable) {
      bg = Colors.white;
      borderColor = AppColors.divider;
      numBg = AppColors.divider;
      numColor = AppColors.textLight;
      trailing = const Icon(Icons.lock, color: AppColors.textLight, size: 20);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: numBg, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text('${level.level}',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: numColor)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(level.title,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isCurrent ? Colors.white : (isAvailable ? AppColors.primaryDark : AppColors.textLight))),
                      if (isCurrent) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(6)),
                          child: Text('BARU', style: GoogleFonts.poppins(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(children: [
                    Icon(Icons.quiz_outlined, size: 12, color: isCurrent ? Colors.white60 : AppColors.textLight),
                    const SizedBox(width: 4),
                    Text(level.subtitle,
                        style: GoogleFonts.poppins(fontSize: 11,
                            color: isCurrent ? Colors.white60 : (isCompleted ? AppColors.textSecondary : AppColors.textLight))),
                    if (isCompleted) ...[
                      const SizedBox(width: 8),
                      Text('· Selesai',
                          style: GoogleFonts.poppins(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w500)),
                    ] else if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Text('· Sedang Berjalan',
                          style: GoogleFonts.poppins(fontSize: 11, color: Colors.white60)),
                    ],
                  ]),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
