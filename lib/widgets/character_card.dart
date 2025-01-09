import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myanimelist/utils/app_colors.dart';

class CharacterCard extends StatelessWidget {
  final String characterName;
  final String characterImageURL;
  final String role;

  const CharacterCard({
    super.key,
    required this.characterName,
    required this.characterImageURL,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        width: 135,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              child: CachedNetworkImage(
                imageUrl: characterImageURL,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: SpinKitDualRing(color: AppColors.primaryColor,)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                characterName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                role,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}