import 'package:flutter/material.dart';
import '../widgets/app_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_state.dart';
import '../data/app_data.dart';
import 'place_detail_screen.dart';

class AllPopularScreen extends StatelessWidget {
  const AllPopularScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final places = AppData.popularPlaces;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Destinasi Populer',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryDark, fontSize: 20)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryDark,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: places.length,
        itemBuilder: (_, i) {
          final place = places[i];
          final isFav = state.isFavorite(place.id);
          return GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: place))),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: AppImage(place.imageUrl,
                            height: 180, width: double.infinity, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(height: 180, color: AppColors.divider)),
                      ),
                      Positioned(
                        top: 10, right: 10,
                        child: GestureDetector(
                          onTap: () => state.toggleFavorite(place.id),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : AppColors.textLight, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(place.name,
                            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.location_on, size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 3),
                          Text(place.location,
                              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                        ]),
                        const SizedBox(height: 8),
                        Row(children: [
                          const Icon(Icons.star, size: 14, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Text('${place.rating}',
                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                          const SizedBox(width: 4),
                          Text('(${place.reviewCount} ulasan)',
                              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
