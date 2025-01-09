
import 'anime_character.dart';

class Anime {
  int malId;
  String title;
  String titleEnglish;
  String imageURL;
  String trailerURL;
  String synopsis;
  String type;
  int episodes;
  int popularity;
  int rank;
  String status;
  double score;
  int scoredBy;
  String date;
  String startDate;
  String endDate;
  String duration;
  String rating;
  List<String> genres;
  List<String> themes;
  List<AnimeCharacter> characters;

  Anime({
    required this.malId,
    required this.title,
    required this.titleEnglish,
    required this.imageURL,
    required this.trailerURL,
    required this.synopsis,
    required this.type,
    required this.episodes,
    required this.popularity,
    required this.rank,
    required this.status,
    required this.score,
    required this.scoredBy,
    required this.startDate,required this.date,
    required this.endDate,
    required this.duration,
    required this.rating,
    required this.genres,
    required this.themes,
    required this.characters,
  });

  static Anime fromMap(Map<String, dynamic> jsonData) {
    return Anime(
      malId: jsonData['mal_id'],
      title: jsonData['title'] ?? '',
      titleEnglish: jsonData['title_english'] ?? jsonData['title'],
      imageURL: jsonData['images']['jpg']['large_image_url'] ?? '',
      trailerURL: jsonData['trailer']?['url'] ?? '',
      synopsis: jsonData['synopsis'] ?? '',
      type: jsonData['type'] ?? '',
      episodes: jsonData['episodes'] ?? 0,
      popularity: jsonData['popularity'] ?? 0,
      rank: jsonData['rank'] ?? 0,
      status: jsonData['status'] ?? '',
      score: (jsonData['score'] ?? 0.0).toDouble(),
      scoredBy: jsonData['scored_by'] ?? 0,
      startDate: jsonData['aired']['from'] ?? '', date: jsonData['aired']['string'] ?? '',
      endDate: jsonData['aired']['to'] ?? '',
      duration: jsonData['duration'] ?? '',
      rating: jsonData['rating'] ?? '',
      genres: (jsonData['genres'] as List).map((genre) => genre['name'] as String).toList(),
      themes: (jsonData['themes'] as List).map((theme) => theme['name'] as String).toList(),
      characters: (jsonData['characters'] as List? ?? []).map((character) => AnimeCharacter.fromMap(character)) .toList(),
    );
  }

  static Map<String, dynamic> toMap(Anime anime) {
    return {
      'mal_id': anime.malId,
      'title': anime.title,
      'title_english': anime.titleEnglish,

      'image_url': anime.imageURL,
      'trailer_url': anime.trailerURL,
      'synopsis': anime.synopsis,
      'type': anime.type,
      'episodes': anime.episodes,
      'popularity': anime.popularity,
      'rank': anime.rank,
      'status': anime.status,
      'score': anime.score,
      'scored_by': anime.scoredBy,
      'start_date': anime.startDate,'date': anime.date,
      'end_date': anime.endDate,
      'duration': anime.duration,
      'rating': anime.rating,
      'genres': anime.genres,
      'themes': anime.themes,
      'characters': anime.characters.map((character) => character.toMap()).toList(),

    };
  }
}
