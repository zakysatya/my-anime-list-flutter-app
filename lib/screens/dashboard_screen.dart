import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myanimelist/models/recommendation.dart';
import 'package:myanimelist/services/api_service.dart';
import 'package:myanimelist/utils/app_colors.dart';
import 'package:myanimelist/utils/image_urls.dart';
import 'package:myanimelist/widgets/recommendation_list_view.dart';  // Import the new widget

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService apiService = ApiService();
  List<Recommendation> recommendations = [];

  @override
  void initState() {
    super.initState();
    fetchRecommendations();

  }

  Future<void> fetchRecommendations() async {
    try {
      final data = await apiService.fetchRecommendations();
      setState(() {
        recommendations = data;
      });
      shuffleRecommendations();
    } catch (e) {
      print(e.toString());
    }
  }

  void shuffleRecommendations() {
    setState(() {
      recommendations.shuffle(Random());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 200.0,
              collapsedHeight: 60,
              floating: false,
              pinned: true,
              stretch: true,
              backgroundColor: AppColors.backgroundColor,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
                title: const Text(
                  "Zs Anime List",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                background: Stack(
                  children: [
                    SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: ImageUrls.appbarBackground,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator()),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.1),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Recommendations",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: shuffleRecommendations,
                    icon: Icon(Icons.shuffle_on_rounded),
                    color: AppColors.primaryColor,
                    
                  ),
                ],
              ),
            ),
            Expanded(
              child: FadeInUp(
                  delay: const Duration(milliseconds: 1000),
                  child: RecommendationListView(recommendations: recommendations)),
            ),
          ],
        ),
      ),
    );
  }
}
