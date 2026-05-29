import 'package:flutter/material.dart';
import '../widgets/app_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_state.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import 'place_detail_screen.dart';

class CategoryPlacesScreen extends StatelessWidget {
  final String category;
  const CategoryPlacesScreen({super.key, required this.category});

  String get _title {
    switch (category) {
      case 'budaya': return 'Budaya';
      case 'religi': return 'Religi';
      case 'alam': return 'Alam';
      default: return category;
    }
  }

  List<TourismPlace> get _places {
    switch (category) {
      case 'budaya': return AppData.budayaPlaces;
      case 'religi': return AppData.religiPlaces;
      case 'alam': return AppData.alamPlaces;
      default: return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final places = _places;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_title,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
                fontSize: 20)),
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
          return GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: place))),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                    child: AppImage(place.imageUrl,
                        width: 110, height: 110, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                            width: 110, height: 110,
                            color: AppColors.divider,
                            child: const Icon(Icons.image, color: AppColors.textLight))),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(place.name,
                              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                          const SizedBox(height: 4),
                          Text(place.shortDesc,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary, height: 1.4)),
                          const SizedBox(height: 6),
                          Row(children: [
                            const Icon(Icons.location_on, size: 11, color: AppColors.textLight),
                            const SizedBox(width: 3),
                            Expanded(child: Text(place.location,
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textLight))),
                          ]),
                          const SizedBox(height: 8),
                          Row(children: [
                            _btn('Selengkapnya', AppColors.primary, Colors.white, () =>
                                Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: place)))),
                            const SizedBox(width: 8),
                            _heartBtn(context, state, place),
                          ]),
                        ],
                      ),
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

  Widget _btn(String label, Color bg, Color fg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
        child: Text(label, style: GoogleFonts.poppins(fontSize: 11, color: fg, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _heartBtn(BuildContext context, AppState state, TourismPlace place) {
    final isFav = state.isFavorite(place.id);
    return GestureDetector(
      onTap: () => state.toggleFavorite(place.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(20)),
        child: Row(children: [
          Icon(isFav ? Icons.favorite : Icons.favorite_border,
              size: 13, color: isFav ? Colors.red : AppColors.textLight),
          const SizedBox(width: 4),
          Text('Favorit', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
        ]),
      ),
    );
  }
}
