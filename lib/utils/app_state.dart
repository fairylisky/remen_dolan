import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/models.dart';
import '../data/app_data.dart';

class AppState extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoggedIn = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // Jika mau load otomatis terakhir login:
    // String? lastUserEmail = _prefs.getString('last_logged_in_email');
    // if (lastUserEmail != null) {
    //   _loadUser(lastUserEmail);
    // }
  }

  void _loadUser(String email) {
    final key = 'user_data_$email';
    final data = _prefs.getString(key);
    if (data != null) {
      _currentUser = UserModel.fromJson(json.decode(data));
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<void> _saveUser() async {
    if (_currentUser == null) return;
    final key = 'user_data_${_currentUser!.email}';
    await _prefs.setString(key, json.encode(_currentUser!.toJson()));
    await _prefs.setString('last_logged_in_email', _currentUser!.email);
  }

  // Login - muat history yang spesifik ke email tersebut
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (email.isNotEmpty && password.length >= 6) {
      final key = 'user_data_$email';
      final data = _prefs.getString(key);

      if (data != null) {
        // User sudah ada di device ini
        _currentUser = UserModel.fromJson(json.decode(data));
      } else {
        // Mocking user baru dari login langsung (fallback)
        final name = email.split('@')[0];
        _currentUser = UserModel(
          id: 'user_${email.hashCode}',
          name: _capitalize(name),
          email: email,
        );
      }
      
      _isLoggedIn = true;
      await _saveUser();
      notifyListeners();
      return true;
    }
    return false;
  }

  // Register - user BARU, tidak ada history quiz
  Future<bool> register(String email, String password, String name) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (email.isNotEmpty && password.length >= 6 && name.isNotEmpty) {
      _currentUser = UserModel(
        id: 'user_new_${email.hashCode}',
        name: _capitalize(name),
        email: email,
        xp: 0,
        level: 1,
        levelTitle: 'Penjelajah Baru',
        quizProgress: [],
        lastQuizSession: null, // baru daftar, belum ada history
      );
      _isLoggedIn = true;
      await _saveUser();
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _prefs.remove('last_logged_in_email');
    notifyListeners();
  }

  void toggleFavorite(String placeId) {
    if (_currentUser == null) return;
    if (_currentUser!.favoriteIds.contains(placeId)) {
      _currentUser!.favoriteIds.remove(placeId);
    } else {
      _currentUser!.favoriteIds.add(placeId);
    }
    _saveUser();
    notifyListeners();
  }

  bool isFavorite(String placeId) =>
      _currentUser?.favoriteIds.contains(placeId) ?? false;

  void toggleSavedArticle(String placeId) {
    if (_currentUser == null) return;
    if (_currentUser!.savedArticleIds.contains(placeId)) {
      _currentUser!.savedArticleIds.remove(placeId);
    } else {
      _currentUser!.savedArticleIds.add(placeId);
    }
    _saveUser();
    notifyListeners();
  }

  bool isArticleSaved(String placeId) =>
      _currentUser?.savedArticleIds.contains(placeId) ?? false;

  List<TourismPlace> get favoritePlaces {
    if (_currentUser == null) return [];
    return AppData.places
        .where((p) => _currentUser!.favoriteIds.contains(p.id))
        .toList();
  }

  List<TourismPlace> get savedArticlePlaces {
    if (_currentUser == null) return [];
    return AppData.places
        .where((p) => _currentUser!.savedArticleIds.contains(p.id))
        .toList();
  }

  QuizProgress? getQuizProgress(String categoryId) {
    return _currentUser?.quizProgress
        .where((p) => p.categoryId == categoryId)
        .firstOrNull;
  }

  void updateQuizProgress(String categoryId, int level, int points, int accuracy) {
    if (_currentUser == null) return;
    var progress = _currentUser!.quizProgress
        .where((p) => p.categoryId == categoryId)
        .firstOrNull;
    if (progress == null) {
      progress = QuizProgress(categoryId: categoryId);
      _currentUser!.quizProgress.add(progress);
    }
    progress.levelCompletion[level] = true;
    progress.currentLevel = level + 1;
    progress.totalPoints += points;
    progress.accuracy = accuracy;
    _currentUser!.xp += points;
    _saveUser();
    notifyListeners();
  }

  void updateLastQuizSession(QuizSession session) {
    if (_currentUser == null) return;
    _currentUser!.lastQuizSession = session;
    _saveUser();
    notifyListeners();
  }

  int get totalProgress {
    if (_currentUser == null) return 0;
    final allCategories = AppData.quizCategories;
    int completedLevels = 0;
    int totalLevels = allCategories.fold(0, (sum, c) => sum + c.levels.length);
    for (final progress in _currentUser!.quizProgress) {
      completedLevels +=
          progress.levelCompletion.values.where((v) => v).length;
    }
    if (totalLevels == 0) return 0;
    return ((completedLevels / totalLevels) * 100).round();
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
