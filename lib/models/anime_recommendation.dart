
class AnimeRecommendation {
  int malId;
  String title;
  String imageURL;

  AnimeRecommendation({
    required this.malId,
    required this.title,
    required this.imageURL,
  });

  static AnimeRecommendation fromMap(Map<String, dynamic> jsonData) {
    return AnimeRecommendation(
      malId: jsonData['mal_id'],
      title: jsonData['title'],
      imageURL: jsonData['images']['jpg']['large_image_url'],
    );
  }

  static Map<String, dynamic> toMap(AnimeRecommendation anime) {
    return {
      'mal_id': anime.malId,
      'title': anime.title,
      'image_url': anime.imageURL,
    };
  }
}
