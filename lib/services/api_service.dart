import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myanimelist/models/anime.dart';
import 'package:myanimelist/utils/constants.dart';

import '../models/anime_character.dart';
import '../models/recommendation.dart';

class ApiService {
  Future<List<Recommendation>> fetchRecommendations() async {
    final response =
        await http.get(Uri.parse(Constants.kRecommendationsBaseURL));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      List<Recommendation> recommendations = [];
      for (var i in data) {
        recommendations.add(Recommendation.fromMap(i));
      }
      return recommendations;
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  Future<Anime> getAnimeById(int malId) async {
    final response =
        await http.get(Uri.parse('${Constants.kAnimeDetailBaseURL}$malId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      final charactersResponse = await http
          .get(Uri.parse('${Constants.kAnimeDetailBaseURL}$malId/characters'));
      if (charactersResponse.statusCode == 200) {
        final charactersData = json.decode(charactersResponse.body)['data'];
        final characters = (charactersData as List)
            .map((character) => AnimeCharacter.fromMap(character))
            .toList();
        final characterMaps =
            characters.map((character) => character.toMap()).toList();

        return Anime.fromMap({...data, 'characters': characterMaps});
      } else {
        throw Exception('Failed to load anime characters');
      }
    } else {
      throw Exception('Failed to load anime details');
    }
  }

  Future<List<AnimeCharacter>> getAnimeCharacters(int malId) async {
    final response = await http
        .get(Uri.parse('${Constants.kAnimeDetailBaseURL}$malId/characters'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];

      return (data as List)
          .map((character) => AnimeCharacter.fromMap(character))
          .toList();
    } else {
      throw Exception('Failed to load anime characters');
    }
  }

  Future<List<Anime>> searchAnime(String query) async {
    final response =
        await http.get(Uri.parse('${Constants.kSearchBaseURL}$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return (data as List).map((anime) => Anime.fromMap(anime)).toList();
    } else {
      throw Exception('Failed to search anime');
    }

  }

  Future<List<Anime>> getTopAnime(String filter) async {
    String url = Constants.kTopAnimeBaseUrl;
    if(filter.isNotEmpty) {
      url += "?filter=$filter";
    }
    print(url);
    final response =
        await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return (data as List).map((anime) => Anime.fromMap(anime)).toList();
    } else {
      throw Exception('Failed to search anime');
    }
  }
}
