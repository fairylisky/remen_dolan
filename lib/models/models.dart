class UserModel {
  final String id;
  String name;
  String email;
  String? photoUrl;
  int xp;
  int level;
  String levelTitle;
  List<String> favoriteIds;
  List<String> savedArticleIds;
  List<QuizProgress> quizProgress;
  QuizSession? lastQuizSession;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.xp = 0,
    this.level = 1,
    this.levelTitle = 'Penjelajah Baru',
    List<String>? favoriteIds,
    List<String>? savedArticleIds,
    List<QuizProgress>? quizProgress,
    this.lastQuizSession,
  })  : favoriteIds = favoriteIds ?? [],
        savedArticleIds = savedArticleIds ?? [],
        quizProgress = quizProgress ?? [];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      xp: json['xp'] ?? 0,
      level: json['level'] ?? 1,
      levelTitle: json['levelTitle'] ?? 'Penjelajah Baru',
      favoriteIds: List<String>.from(json['favoriteIds'] ?? []),
      savedArticleIds: List<String>.from(json['savedArticleIds'] ?? []),
      quizProgress: (json['quizProgress'] as List?)
              ?.map((e) => QuizProgress.fromJson(e))
              .toList() ??
          [],
      lastQuizSession: json['lastQuizSession'] != null
          ? QuizSession.fromJson(json['lastQuizSession'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'xp': xp,
      'level': level,
      'levelTitle': levelTitle,
      'favoriteIds': favoriteIds,
      'savedArticleIds': savedArticleIds,
      'quizProgress': quizProgress.map((e) => e.toJson()).toList(),
      'lastQuizSession': lastQuizSession?.toJson(),
    };
  }
}

class QuizProgress {
  final String categoryId;
  int currentLevel;
  int totalPoints;
  int accuracy;
  Map<int, bool> levelCompletion;

  QuizProgress({
    required this.categoryId,
    this.currentLevel = 1,
    this.totalPoints = 0,
    this.accuracy = 0,
    Map<int, bool>? levelCompletion,
  }) : levelCompletion = levelCompletion ?? {};

  factory QuizProgress.fromJson(Map<String, dynamic> json) {
    return QuizProgress(
      categoryId: json['categoryId'],
      currentLevel: json['currentLevel'] ?? 1,
      totalPoints: json['totalPoints'] ?? 0,
      accuracy: json['accuracy'] ?? 0,
      levelCompletion: (json['levelCompletion'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(int.parse(k), v as bool)) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'currentLevel': currentLevel,
      'totalPoints': totalPoints,
      'accuracy': accuracy,
      'levelCompletion':
          levelCompletion.map((k, v) => MapEntry(k.toString(), v)),
    };
  }
}

class QuizSession {
  final String placeName;
  final String categoryId;
  final int questionsAnswered;
  final int totalQuestions;
  final int score;
  final DateTime date;

  QuizSession({
    required this.placeName,
    required this.categoryId,
    required this.questionsAnswered,
    required this.totalQuestions,
    required this.score,
    required this.date,
  });

  factory QuizSession.fromJson(Map<String, dynamic> json) {
    return QuizSession(
      placeName: json['placeName'],
      categoryId: json['categoryId'],
      questionsAnswered: json['questionsAnswered'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      score: json['score'] ?? 0,
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeName': placeName,
      'categoryId': categoryId,
      'questionsAnswered': questionsAnswered,
      'totalQuestions': totalQuestions,
      'score': score,
      'date': date.toIso8601String(),
    };
  }
}

class TourismPlace {
  final String id;
  final String name;
  final String category; // budaya, religi, alam
  final String shortDesc;
  final String description;
  final String history;
  final String imageUrl;
  final List<String> galleryUrls;
  final String location;
  final String address;
  final double lat;
  final double lng;
  final double rating;
  final int reviewCount;
  final String ticketPrice;
  final String openHours;
  final String funFact;
  final String quote;
  final bool isPopular;
  final List<QuizQuestion> quizQuestions;

  TourismPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.shortDesc,
    required this.description,
    required this.history,
    required this.imageUrl,
    required this.galleryUrls,
    required this.location,
    required this.address,
    required this.lat,
    required this.lng,
    required this.rating,
    required this.reviewCount,
    required this.ticketPrice,
    required this.openHours,
    required this.funFact,
    required this.quote,
    this.isPopular = false,
    required this.quizQuestions,
  });
}

class QuizQuestion {
  final String id;
  final String question;
  final String imageUrl;
  final List<String> options;
  final int correctIndex;
  final String hint;
  final String explanation;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.imageUrl,
    required this.options,
    required this.correctIndex,
    required this.hint,
    required this.explanation,
  });
}

class QuizCategory {
  final String id;
  final String name;
  final String subtitle;
  final String imageUrl;
  final int totalQuestions;
  final List<QuizLevel> levels;

  QuizCategory({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.totalQuestions,
    required this.levels,
  });
}

class QuizLevel {
  final int level;
  final String title;
  final String subtitle;
  final List<QuizQuestion> questions;

  QuizLevel({
    required this.level,
    required this.title,
    required this.subtitle,
    required this.questions,
  });
}

class LearnArticle {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String tag;
  final String content;
  final int quizCount;
  final int photoCount;
  final String placeId;

  LearnArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.tag,
    required this.content,
    required this.quizCount,
    required this.photoCount,
    required this.placeId,
  });
}
