import 'package:flutter/material.dart';
import '../widgets/app_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_state.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import 'quiz_level_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final categories = AppData.quizCategories;

    return CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.background,
            floating: true,
            elevation: 0,
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: AppColors.primaryDark),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            title: Text('Remen Dolan',
                style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            actions: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.divider,
                child: Text(state.currentUser?.name.substring(0, 1).toUpperCase() ?? 'U',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryDark, fontSize: 14)),
              ),
              const SizedBox(width: 16),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('PILIH TANTANGAN',
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text('Uji Pengetahuanmu',
                      style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                  const SizedBox(height: 6),
                  Text('Jelajahi kearifan lokal melalui kuis interaktif yang mendalam dan edukatif.',
                      style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
                  const SizedBox(height: 20),
                  ...categories.map((cat) {
                    final progress = state.getQuizProgress(cat.id);
                    final answered = progress?.levelCompletion.values.where((v) => v).length ?? 0;
                    final total = cat.levels.length;
                    final questionsDone = answered * 10;
                    final totalQ = cat.totalQuestions;

                    return GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => QuizLevelScreen(category: cat))),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                  child: AppImage(cat.imageUrl,
                                      height: 160, width: double.infinity, fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(height: 160, color: AppColors.divider)),
                                ),
                                Container(
                                  height: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 12, left: 14,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.accent.withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(cat.subtitle,
                                            style: GoogleFonts.poppins(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w500)),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(cat.name,
                                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Progress Belajar',
                                          style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                                      Text('$questionsDone/$totalQ Soal',
                                          style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  LinearProgressIndicator(
                                    value: total > 0 ? answered / total : 0,
                                    backgroundColor: AppColors.divider,
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                                    borderRadius: BorderRadius.circular(4),
                                    minHeight: 6,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      );
  }
}
