import 'package:flutter/material.dart';
import '../widgets/app_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_state.dart';
import 'home_screen.dart';
import 'learn_screen.dart';
import 'quiz_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'category_places_screen.dart';
import 'place_detail_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      // Drawer di sini - satu-satunya Scaffold yang punya drawer
      drawer: _buildSidebar(context, state, user),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    // Semua screen ini TIDAK boleh punya Scaffold sendiri
    switch (_currentIndex) {
      case 0: return const HomeScreen();
      case 1: return const LearnScreen();
      case 2: return const QuizScreen();
      case 3: return const MapScreen();
      case 4: return const ProfileScreen();
      default: return const HomeScreen();
    }
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.home_rounded, 'Home'),
              _navItem(1, Icons.menu_book_rounded, 'Learn'),
              _navItem(2, Icons.quiz_rounded, 'Quiz'),
              _navItem(3, Icons.map_rounded, 'Map'),
              _navItem(4, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: isSelected ? AppColors.primary : AppColors.textLight),
          ),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppColors.primary : AppColors.textLight,
          )),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, AppState state, dynamic user) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            decoration: const BoxDecoration(color: AppColors.primaryDark),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.accent,
                  child: Text(
                    user?.name.isNotEmpty == true
                        ? user!.name[0].toUpperCase()
                        : 'U',
                    style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                Text(user?.name ?? 'Pengguna',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 2),
                Text(user?.email ?? '',
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.white60)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'LK ${user?.level ?? 1} · ${user?.levelTitle ?? "Penjelajah Baru"}',
                    style: GoogleFonts.poppins(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: ((user?.xp ?? 0) / 3000).clamp(0.0, 1.0),
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                Text('${user?.xp ?? 0} / 3,000 XP menuju Level ${(user?.level ?? 1) + 1}',
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _sectionLabel('MENU UTAMA'),
                _drawerItem(Icons.home_rounded, 'Beranda', () {
                  Navigator.pop(context);
                  setState(() => _currentIndex = 0);
                }),
                _drawerItemBadge(Icons.favorite_rounded, 'Favorit Saya',
                    state.favoritePlaces.length, () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FavoritesPage()));
                }),
                _drawerItemBadge(Icons.bookmark_rounded, 'Artikel Tersimpan',
                    state.savedArticlePlaces.length, () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SavedArticlesPage()));
                }),
                _divider(),
                _sectionLabel('EKSPLORASI'),
                _drawerItem(Icons.landscape_rounded, 'Wisata Alam', () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const CategoryPlacesScreen(category: 'alam')));
                }),
                _drawerItem(Icons.account_balance_rounded, 'Wisata Budaya', () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const CategoryPlacesScreen(category: 'budaya')));
                }),
                _drawerItem(Icons.mosque_rounded, 'Wisata Religi', () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const CategoryPlacesScreen(category: 'religi')));
                }),
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Divider(color: AppColors.divider),
                ),
                _drawerItem(Icons.logout_rounded, 'Keluar', () {
                  Navigator.pop(context);
                  _confirmLogout(context, state);
                }, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
    child: Text(text, style: GoogleFonts.poppins(
        fontSize: 11, fontWeight: FontWeight.w600,
        color: AppColors.textLight, letterSpacing: 0.5)),
  );

  Widget _drawerItem(IconData icon, String label, VoidCallback onTap, {Color? color}) =>
      ListTile(
        leading: Icon(icon, color: color ?? AppColors.primaryDark, size: 22),
        title: Text(label, style: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w500,
            color: color ?? AppColors.textPrimary)),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        dense: true,
      );

  Widget _drawerItemBadge(IconData icon, String label, int count, VoidCallback onTap) =>
      ListTile(
        leading: Icon(icon, color: AppColors.primaryDark, size: 22),
        title: Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: count > 0
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                child: Text('$count', style: GoogleFonts.poppins(
                    fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
              )
            : null,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        dense: true,
      );

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Divider(color: AppColors.divider),
  );

  void _confirmLogout(BuildContext context, AppState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Keluar', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin keluar?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx),
              child: Text('Batal', style: GoogleFonts.poppins())),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              state.logout();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark),
            child: Text('Keluar', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final places = context.watch<AppState>().favoritePlaces;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Favorit Saya', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, foregroundColor: AppColors.primaryDark, elevation: 0,
      ),
      body: places.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.favorite_border, size: 64, color: AppColors.textLight),
              const SizedBox(height: 16),
              Text('Belum ada favorit', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
            ]))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: places.length,
              itemBuilder: (_, i) {
                final p = places[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AppImage(p.imageUrl, width: 56, height: 56, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 56, height: 56, color: AppColors.divider)),
                    ),
                    title: Text(p.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    subtitle: Text(p.location,
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                  ),
                );
              }),
    );
  }
}

class SavedArticlesPage extends StatelessWidget {
  const SavedArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final places = context.watch<AppState>().savedArticlePlaces;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Artikel Tersimpan', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, foregroundColor: AppColors.primaryDark, elevation: 0,
      ),
      body: places.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.bookmark_border, size: 64, color: AppColors.textLight),
              const SizedBox(height: 16),
              Text('Belum ada artikel tersimpan', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
            ]))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: places.length,
              itemBuilder: (_, i) {
                final p = places[i];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: p)),
                  ),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AppImage(p.imageUrl, width: 56, height: 56, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 56, height: 56, color: AppColors.divider)),
                      ),
                      title: Text(p.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      subtitle: Text(p.location,
                          style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                    ),
                  ),
                );
              }),
    );
  }
}
