import 'package:flutter/material.dart';
import '../widgets/app_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_state.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import 'place_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TourismPlace? _selected;
  final MapController _mapController = MapController();
  String _filter = 'semua';

  List<TourismPlace> get _filteredPlaces {
    if (_filter == 'semua') return AppData.places;
    return AppData.places.where((p) => p.category == _filter).toList();
  }

  Color _markerColor(String cat) {
    switch (cat) {
      case 'budaya': return AppColors.primaryDark;
      case 'religi': return Colors.teal;
      case 'alam': return Colors.green;
      default: return AppColors.primary;
    }
  }

  IconData _markerIcon(String cat) {
    switch (cat) {
      case 'religi': return Icons.mosque;
      case 'alam': return Icons.landscape;
      default: return Icons.account_balance;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(-7.7956, 110.3695),
              initialZoom: 11,
              onTap: (_, __) => setState(() => _selected = null),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.remendolan.app',
              ),
              MarkerLayer(
                markers: _filteredPlaces.map((place) {
                  return Marker(
                    point: LatLng(place.lat, place.lng),
                    width: 36,
                    height: 36,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selected = place);
                        _mapController.move(LatLng(place.lat, place.lng), 14);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _markerColor(place.category),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        ),
                        child: Icon(
                          _markerIcon(place.category),
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Top bar
          SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      Builder(
                        builder: (ctx) => GestureDetector(
                          onTap: () => Scaffold.of(ctx).openDrawer(),
                          child: const Icon(Icons.menu_rounded, color: AppColors.primaryDark),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Remen Dolan',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          final result = await showSearch<TourismPlace?>(
                            context: context,
                            delegate: PlaceSearchDelegate(AppData.places),
                          );
                          if (result != null) {
                            setState(() => _selected = result);
                            _mapController.move(LatLng(result.lat, result.lng), 14);
                          }
                        },
                        child: const Icon(Icons.search, color: AppColors.primaryDark),
                      ),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.divider,
                        child: Icon(Icons.person, size: 18, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _chip('semua', 'Semua'),
                      const SizedBox(width: 8),
                      _chip('budaya', 'Budaya'),
                      const SizedBox(width: 8),
                      _chip('religi', 'Religi'),
                      const SizedBox(width: 8),
                      _chip('alam', 'Alam'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom place card
          if (_selected != null)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: _selected!)),
                ),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 16)],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AppImage(
                          _selected!.imageUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 70, height: 70,
                            color: AppColors.divider,
                            child: const Icon(Icons.image, color: AppColors.textLight),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DESTINASI POPULER',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selected!.name,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(children: [
                              const Icon(Icons.star, size: 12, color: AppColors.accent),
                              const SizedBox(width: 3),
                              Text(
                                '${_selected!.rating}',
                                style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.near_me, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Zoom buttons
          Positioned(
            top: 160,
            right: 16,
            child: Column(
              children: [
                _mapBtn(Icons.add, () {
                  _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  );
                }),
                const SizedBox(height: 4),
                _mapBtn(Icons.remove, () {
                  _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String val, String label) {
    final selected = _filter == val;
    return GestureDetector(
      onTap: () => setState(() => _filter = val),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6)],
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _mapBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)],
        ),
        child: Icon(icon, size: 20, color: AppColors.primaryDark),
      ),
    );
  }
}

class PlaceSearchDelegate extends SearchDelegate<TourismPlace?> {
  final List<TourismPlace> places;

  PlaceSearchDelegate(this.places);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = places.where((place) {
      return place.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (suggestions.isEmpty) {
      return Center(
        child: Text('Tempat tidak ditemukan',
            style: GoogleFonts.poppins(color: AppColors.textSecondary)),
      );
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final place = suggestions[index];
        return ListTile(
          leading: const Icon(Icons.location_on, color: AppColors.primary),
          title: Text(place.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          subtitle: Text(place.category, style: GoogleFonts.poppins(fontSize: 12)),
          onTap: () => close(context, place),
        );
      },
    );
  }
}

