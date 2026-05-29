import 'package:flutter/material.dart';
import '../widgets/app_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_state.dart';
import '../models/models.dart';
import 'quiz_play_screen.dart';

class PlaceDetailScreen extends StatefulWidget {
  final TourismPlace place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final place = widget.place;
    final isFav = state.isFavorite(place.id);
    final isSaved = state.isArticleSaved(place.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(place.imageUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: AppColors.background)),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16, left: 16, right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(place.category.toUpperCase(),
                              style: GoogleFonts.poppins(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(height: 6),
                        Text(place.name,
                            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.location_on, size: 13, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(place.location,
                              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                  child: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white, size: 18),
                ),
                onPressed: () => state.toggleFavorite(place.id),
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                  child: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, 
                      color: isSaved ? AppColors.accent : Colors.white, size: 18),
                ),
                onPressed: () => state.toggleSavedArticle(place.id),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Tab bar
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tab,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    labelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(text: 'Artikel'),
                      Tab(text: 'Info'),
                      Tab(text: 'Quiz'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 800,
                  child: TabBarView(
                    controller: _tab,
                    children: [
                      _ArticleTab(place: place),
                      _InfoTab(place: place),
                      _QuizTab(place: place),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleTab extends StatelessWidget {
  final TourismPlace place;
  const _ArticleTab({required this.place});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tentang ${place.name}',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
          const SizedBox(height: 12),
          Text(place.description,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary, height: 1.7)),
          const SizedBox(height: 20),
          _sectionTitle('Sejarah'),
          const SizedBox(height: 8),
          Text(place.history,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary, height: 1.7)),
          const SizedBox(height: 20),
          _funFactCard(place.funFact),
          const SizedBox(height: 20),
          _quoteCard(place.quote),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t,
      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark));

  Widget _funFactCard(String fact) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fun Fact!',
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                const SizedBox(height: 4),
                Text(fact,
                    style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quoteCard(String quote) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('"', style: TextStyle(fontSize: 48, color: AppColors.accent, height: 0.8)),
          const SizedBox(height: 8),
          Text(quote,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 14, color: Colors.white, fontStyle: FontStyle.italic, height: 1.6)),
        ],
      ),
    );
  }
}

class _InfoTab extends StatelessWidget {
  final TourismPlace place;
  const _InfoTab({required this.place});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _infoCard(Icons.attach_money_rounded, 'Harga Tiket', place.ticketPrice),
          const SizedBox(height: 12),
          _infoCard(Icons.access_time_rounded, 'Jam Buka', place.openHours),
          const SizedBox(height: 12),
          _infoCard(Icons.location_on_rounded, 'Alamat', place.address),
          const SizedBox(height: 12),
          _infoCard(Icons.star_rounded, 'Rating',
              '${place.rating} ⭐ (${place.reviewCount.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')} ulasan)'),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value,
                    style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizTab extends StatelessWidget {
  final TourismPlace place;
  const _QuizTab({required this.place});

  @override
  Widget build(BuildContext context) {
    final questions = place.quizQuestions;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quiz: ${place.name}',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
          const SizedBox(height: 4),
          Text('${questions.length} soal tersedia',
              style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AppImage(place.imageUrl,
                      height: 160, width: double.infinity, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(height: 160, color: AppColors.divider)),
                ),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _stat('${questions.length}', 'Soal'),
                  _divider(),
                  _stat('${(questions.length * 1.5).round()}', 'Menit'),
                  _divider(),
                  _stat('10', 'Poin/Soal'),
                ]),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizPlayScreen(
                          questions: questions,
                          title: place.name,
                          categoryId: place.category,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Mulai Quiz',
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String val, String label) {
    return Column(children: [
      Text(val, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
      Text(label, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
    ]);
  }

  Widget _divider() => Container(width: 1, height: 30, color: AppColors.divider);
}
