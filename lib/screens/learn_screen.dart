import 'package:flutter/material.dart';
import '../widgets/app_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_state.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import 'place_detail_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> with SingleTickerProviderStateMixin {
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
    return NestedScrollView(
      headerSliverBuilder: (context, _) => [
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
          bottom: TabBar(
            controller: _tab,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            labelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
            tabs: const [Tab(text: 'Budaya'), Tab(text: 'Religi'), Tab(text: 'Alam')],
          ),
        ),
      ],
      body: TabBarView(
        controller: _tab,
        children: [
          _PlaceLearnList(places: AppData.budayaPlaces, tag: 'PUSAT BUDAYA JAWA'),
          _PlaceLearnList(places: AppData.religiPlaces, tag: 'WARISAN SPIRITUAL'),
          _PlaceLearnList(places: AppData.alamPlaces, tag: 'ALAM NUSANTARA'),
        ],
      ),
    );
  }
}

class _PlaceLearnList extends StatelessWidget {
  final List<TourismPlace> places;
  final String tag;
  const _PlaceLearnList({required this.places, required this.tag});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: places.length,
      itemBuilder: (_, i) {
        final place = places[i];
        return GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: place))),
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
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
                      child: AppImage(place.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(height: 200, color: AppColors.divider,
                              child: const Icon(Icons.image, size: 48, color: AppColors.textLight))),
                    ),
                    Positioned(
                      top: 12, left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.primaryDark.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(tag,
                            style: GoogleFonts.poppins(fontSize: 10, color: Colors.white,
                                fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(place.name,
                          style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                      const SizedBox(height: 6),
                      Text(place.shortDesc, maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
                      const SizedBox(height: 12),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.quiz_outlined, size: 14, color: AppColors.textLight),
                          const SizedBox(width: 4),
                          Text('${place.quizQuestions.length} Soal',
                              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(width: 16),
                          Icon(Icons.photo_library_outlined, size: 14, color: AppColors.textLight),
                          const SizedBox(width: 4),
                          Text('${place.galleryUrls.length + 4} Foto',
                              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: place))),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryDark, borderRadius: BorderRadius.circular(20)),
                              child: Row(children: [
                                Text('Mulai Belajar',
                                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                              ]),
                            ),
                          ),
                        ],
                      ),
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
