import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myanimelist/models/recommendation.dart';
import 'package:myanimelist/screens/anime_detail_page.dart';
import 'package:myanimelist/utils/app_colors.dart';
import 'package:myanimelist/widgets/anime_card.dart';

import '../screens/recommendation_detail_page.dart'; // Updated import

class RecommendationListView extends StatelessWidget {
  final List<Recommendation> recommendations;

  const RecommendationListView({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final recommendation = recommendations[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
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
                          },
                          title: anime.title,
                          colorText: AppColors.textPrimaryColor),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(recommendation.user.username),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecommendationDetailPage(
                              recommendation: recommendation,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle:
                            GoogleFonts.roboto(fontWeight: FontWeight.bold),
                        elevation: 4,
                        backgroundColor: AppColors.buttonSecondaryColor,
                      ),
                      child: const Text(
                        'View Recommendation',
                        style: TextStyle(
                            fontSize: 16, color: AppColors.textSecondaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
