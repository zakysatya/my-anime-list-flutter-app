import 'anime_recommendation.dart';

class Recommendation {
  String content;
  DateTime date;
  User user;
  List<AnimeRecommendation> animeRecommendations;

  Recommendation({
    required this.content,
    required this.date,
    required this.user,
    required this.animeRecommendations,
  });

  static Recommendation fromMap(Map<String, dynamic> jsonData) {
    return Recommendation(
      content: jsonData['content'],
      date: DateTime.parse(jsonData['date']).toLocal(),
      user: User.fromMap(jsonData['user']),
      animeRecommendations: (jsonData['entry'] as List)
          .map((e) => AnimeRecommendation.fromMap(e))
          .toList(),
    );
  }

  static Map<String, dynamic> toMap(Recommendation recommendation) {
    return {
      'content': recommendation.content,
      'date': recommendation.date.toIso8601String(),
      'user': User.toMap(recommendation.user),
      'entry': recommendation.animeRecommendations
          .map((e) => AnimeRecommendation.toMap(e))
          .toList(),
    };
  }
}

class User {
  String url;
  String username;

  User({
    required this.url,
    required this.username,
  });

  static User fromMap(Map<String, dynamic> jsonData) {
    return User(
      url: jsonData['url'],
      username: jsonData['username'],
    );
  }

  static Map<String, dynamic> toMap(User user) {
    return {
      'url': user.url,
      'username': user.username,
    };
  }
}
