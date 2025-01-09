import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myanimelist/utils/app_colors.dart';
class AnimeCard extends StatelessWidget {
  final String imageURL;
  final VoidCallback onTap;
  final String title;
  final Color colorText;

  const AnimeCard({
    super.key,
    required this.imageURL,

    required this.onTap, required this.title, required this.colorText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            child: SizedBox(
              width: 160, // Set a fixed width
              height: 250, // Set a fixed height
              child: ClipRRect(
                borderRadius:
                const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: imageURL,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: SpinKitDualRing(color: AppColors.primaryColor,),
                  ),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: colorText),
          ),
        ],
      ),
    );
  }
}
