
import 'package:flutter/material.dart';
import 'package:myanimelist/models/recommendation.dart';
import 'package:myanimelist/utils/app_colors.dart';
import 'package:myanimelist/widgets/anime_card.dart';
import 'anime_detail_page.dart';

class RecommendationDetailPage extends StatelessWidget {
  final Recommendation recommendation;

  const RecommendationDetailPage({Key? key, required this.recommendation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Recommendation Detail', style: TextStyle()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: recommendation.animeRecommendations.map((anime) {
                  return Expanded(
                    child: AnimeCard(
                        imageURL: anime.imageURL,
                        onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AnimeDetailPage(malId: anime.malId),
                        ),
                      );
                    }, title: anime.title, colorText: AppColors.textSecondaryColor,)
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Card(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12))
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '"${recommendation.content}"',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Recommended by: ${recommendation.user.username}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
