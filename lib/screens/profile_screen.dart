import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_state.dart';
import '../data/app_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;

    // Guard: jika user null, tampilkan loading
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final totalFav = state.favoritePlaces.length;
    final totalSaved = state.savedArticlePlaces.length;

    // Hitung total quiz yang sudah dikerjakan
    int totalDoneLevels = 0;
    int totalAllLevels = 0;
    for (final cat in AppData.quizCategories) {
      final p = state.getQuizProgress(cat.id);
      totalDoneLevels += p?.levelCompletion.values.where((v) => v).length ?? 0;
      totalAllLevels += cat.levels.length;
    }
    final overallProgress = totalAllLevels > 0
        ? (totalDoneLevels / totalAllLevels * 100).round()
        : 0;

    // Tidak ada Scaffold di sini! MainScreen yang punya Scaffold+Drawer
    return CustomScrollView(
      slivers: [
        // ===== APP BAR / HEADER PROFIL =====
        SliverAppBar(
          backgroundColor: AppColors.primaryDark,
          pinned: true,
          expandedHeight: 240,
          // Menu button untuk buka drawer dari parent MainScreen
          leading: Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: AppColors.primaryDark,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 36),
                    // Foto profil (avatar dengan inisial nama)
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Center(
                        child: Text(
                          user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                          style: GoogleFonts.poppins(
                              fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Nama lengkap
                    Text(user.name,
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 2),
                    // Email
                    Text(user.email,
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60)),
                    const SizedBox(height: 8),
                    // Badge level
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.accent.withOpacity(0.6)),
                      ),
                      child: Text(
                        'Level ${user.level} · ${user.levelTitle}',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [

              // ===== XP PROGRESS BAR =====
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Pengalaman (XP)',
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                    Text('${user.xp} / 3,000 XP',
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: (user.xp / 3000).clamp(0.0, 1.0),
                    backgroundColor: AppColors.divider,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    borderRadius: BorderRadius.circular(6), minHeight: 10,
                  ),
                  const SizedBox(height: 6),
                  Text('Menuju Level ${user.level + 1}',
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLight)),
                ]),
              ),
              const SizedBox(height: 16),

              // ===== STATISTIK SINGKAT =====
              Row(children: [
                Expanded(child: _statCard('$overallProgress%', 'Progress\nBelajar', Icons.school_rounded, AppColors.primary)),
                const SizedBox(width: 12),
                Expanded(child: _statCard('$totalFav', 'Tempat\nFavorit', Icons.favorite_rounded, Colors.redAccent)),
                const SizedBox(width: 12),
                Expanded(child: _statCard('$totalSaved', 'Artikel\nTersimpan', Icons.bookmark_rounded, AppColors.accent)),
              ]),
              const SizedBox(height: 16),

              // ===== PROGRESS QUIZ PER KATEGORI =====
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Progress Quiz', style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                    Text('$totalDoneLevels/$totalAllLevels Level',
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                  ]),
                  const SizedBox(height: 16),

                  // Budaya
                  _quizCategoryProgress(context, state, 'budaya', 'Wisata Budaya',
                      Icons.account_balance_rounded, AppColors.primaryDark),
                  const SizedBox(height: 14),

                  // Religi
                  _quizCategoryProgress(context, state, 'religi', 'Wisata Religi',
                      Icons.mosque_rounded, Colors.teal),
                  const SizedBox(height: 14),

                  // Alam
                  _quizCategoryProgress(context, state, 'alam', 'Wisata Alam',
                      Icons.landscape_rounded, Colors.green),
                ]),
              ),
              const SizedBox(height: 16),

              // ===== RIWAYAT QUIZ TERAKHIR =====
              if (user.lastQuizSession != null) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Aktivitas Terakhir', style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                    const SizedBox(height: 14),
                    _lastSessionCard(user.lastQuizSession!),
                  ]),
                ),
                const SizedBox(height: 16),
              ],

              // ===== INFO AKUN =====
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Informasi Akun', style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                  const SizedBox(height: 14),
                  _infoRow(Icons.person_outline, 'Nama', user.name),
                  const Divider(color: AppColors.divider, height: 20),
                  _infoRow(Icons.email_outlined, 'Email', user.email),
                  const Divider(color: AppColors.divider, height: 20),
                  _infoRow(Icons.military_tech_outlined, 'Level', '${user.level} - ${user.levelTitle}'),
                ]),
              ),
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _statCard(String val, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(val, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(label, textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textSecondary)),
      ]),
    );
  }

  Widget _quizCategoryProgress(BuildContext context, AppState state,
      String categoryId, String label, IconData icon, Color color) {
    final cat = AppData.quizCategories.firstWhere((c) => c.id == categoryId);
    final p = state.getQuizProgress(categoryId);
    final done = p?.levelCompletion.values.where((v) => v).length ?? 0;
    final total = cat.levels.length;
    final pct = total > 0 ? done / total : 0.0;
    final points = p?.totalPoints ?? 0;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: GoogleFonts.poppins(
            fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
        Text('$done/$total Level', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
      ]),
      const SizedBox(height: 6),
      LinearProgressIndicator(
        value: pct,
        backgroundColor: AppColors.divider,
        valueColor: AlwaysStoppedAnimation<Color>(color),
        borderRadius: BorderRadius.circular(4), minHeight: 7,
      ),
      const SizedBox(height: 4),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(done == 0 ? 'Belum dimulai' : '$done level selesai',
            style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLight)),
        Text('$points poin',
            style: GoogleFonts.poppins(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
      ]),
    ]);
  }

  Widget _lastSessionCard(dynamic session) {
    final catIcon = session.categoryId == 'alam'
        ? Icons.landscape_rounded
        : session.categoryId == 'religi'
            ? Icons.mosque_rounded
            : Icons.account_balance_rounded;
    final catColor = session.categoryId == 'alam'
        ? Colors.green
        : session.categoryId == 'religi'
            ? Colors.teal
            : AppColors.primaryDark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: catColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(catIcon, color: catColor, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(session.placeName, style: GoogleFonts.poppins(
              fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
          const SizedBox(height: 2),
          Text('${session.questionsAnswered}/${session.totalQuestions} soal benar',
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${session.score}', style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
          Text('poin', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLight)),
        ]),
      ]),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, size: 18, color: AppColors.primaryDark),
      const SizedBox(width: 12),
      Text('$label: ', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
      Expanded(child: Text(value, style: GoogleFonts.poppins(
          fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          overflow: TextOverflow.ellipsis)),
    ]);
  }
}
