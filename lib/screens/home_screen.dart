import 'package:flutter/material.dart';
import '../widgets/app_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_state.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import 'place_detail_screen.dart';
import 'category_places_screen.dart';
import 'all_popular_screen.dart';
import 'quiz_screen.dart';
import 'quiz_level_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;

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
              style: GoogleFonts.playfairDisplay(
                  fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
          actions: [
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.accent,
                child: Text(
                  user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                ),
              ),
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
                Text('Halo, ${user?.name ?? "Penjelajah"}!',
                    style: GoogleFonts.poppins(fontSize: 14, color: AppColors.primaryDark, fontWeight: FontWeight.w500)),
                Text('Sugeng Rawuh',
                    style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                const SizedBox(height: 6),
                Text('Temukan harmoni tradisi dan kenyamanan modern di pusat kebudayaan Jawa.',
                    style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
                const SizedBox(height: 20),

                // ===== LEARNING PATH =====
                if (user?.lastQuizSession != null) ...[
                  _LearningPathCard(user: user!, parentContext: context),
                  const SizedBox(height: 24),
                ],

                // ===== KATEGORI EKSPLORASI =====
                Text('Kategori Eksplorasi',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                const SizedBox(height: 12),
                _buildCategoryGrid(context),
                const SizedBox(height: 24),

                // ===== DESTINASI POPULER =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Destinasi Populer',
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const AllPopularScreen())),
                      child: Text('Lihat Semua',
                          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildPopularGrid(context, state),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    return Column(children: [
      _CategoryCard(
        label: 'Budaya', sublabel: 'Warisan Leluhur & Seni',
        imageUrl: 'assets/images/candi.jpg',
        height: 160,
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CategoryPlacesScreen(category: 'budaya'))),
      ),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _CategoryCard(
          label: 'Alam',
          imageUrl: 'assets/images/pantai.jpg',
          height: 130,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CategoryPlacesScreen(category: 'alam'))),
        )),
        const SizedBox(width: 12),
        Expanded(child: _CategoryCard(
          label: 'Religi',
          imageUrl: 'assets/images/masjid.jpg',
          height: 130,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CategoryPlacesScreen(category: 'religi'))),
        )),
      ]),
    ]);
  }

  Widget _buildPopularGrid(BuildContext context, AppState state) {
    final popular = AppData.popularPlaces.take(4).toList();
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.05,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: popular.length,
      itemBuilder: (_, i) {
        final place = popular[i];
        return GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: place))),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: AppImage(
                      place.imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          height: 120,
                          color: AppColors.divider,
                          child: const Icon(Icons.image, color: AppColors.textLight)),
                    ),
                  ),
                  Positioned(
                    top: 8, right: 8,
                    child: GestureDetector(
                      onTap: () => state.toggleFavorite(place.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          state.isFavorite(place.id) ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: state.isFavorite(place.id) ? Colors.red : AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(place.name,
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Row(children: [
                        const Icon(Icons.location_on, size: 11, color: AppColors.textLight),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            place.location.split(',').first,
                            style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLight),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ===== Category Card Widget =====
class _CategoryCard extends StatelessWidget {
  final String label;
  final String? sublabel;
  final String imageUrl;
  final double height;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.label, this.sublabel,
    required this.imageUrl, required this.height, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(children: [
          AppImage(imageUrl, height: height, width: double.infinity, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(height: height, color: AppColors.divider)),
          Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.65)],
              ),
            ),
          ),
          Positioned(bottom: 14, left: 14, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
            if (sublabel != null)
              Text(sublabel!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ])),
        ]),
      ),
    );
  }
}

// ===== Learning Path Card =====
class _LearningPathCard extends StatelessWidget {
  final dynamic user;
  final BuildContext parentContext;
  const _LearningPathCard({required this.user, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    final session = user.lastQuizSession;
    final progress = ((user.xp ?? 0) / 3000).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 3))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(20)),
            child: Text('Learning Path',
                style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
          ),
        ]),
        const SizedBox(height: 8),
        Text('Progres ${user.levelTitle}',
            style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
        if (session != null) ...[
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.history, size: 13, color: AppColors.textLight),
            const SizedBox(width: 4),
            Text('Terakhir: ${session.placeName} · ${session.score} poin',
                style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          ]),
        ],
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.divider,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          borderRadius: BorderRadius.circular(4),
          minHeight: 6,
        ),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Level ${user.level} Explorer',
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          Text('${(progress * 100).round()}% Selesai',
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
        ]),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            if (session == null) return;

            final categories = AppData.quizCategories;
            final cat = categories.firstWhere(
              (c) => c.id == session.categoryId,
              orElse: () => categories.first,
            );

            Navigator.of(parentContext).push(
              MaterialPageRoute(
                builder: (_) => QuizLevelScreen(category: cat),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: AppColors.primaryDark, borderRadius: BorderRadius.circular(24)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('Lanjutkan Kuis',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
            ]),
          ),
        ),
      ]),
    );
  }
}