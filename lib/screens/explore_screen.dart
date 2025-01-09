import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myanimelist/models/anime.dart';
import 'package:myanimelist/services/api_service.dart';
import 'package:myanimelist/screens/anime_detail_page.dart';
import 'package:myanimelist/utils/app_colors.dart';
import 'package:myanimelist/widgets/search_anime_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Anime> _searchResults = [];
  List<Anime> _topAnime = [];
  List<Anime> _favoriteAnime = [];
  List<Anime> _airingAnime = [];

  bool _isLoading = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final topResults = await apiService.getTopAnime("");
      final favoriteResults = await apiService.getTopAnime("favorite");
      final airingResults = await apiService.getTopAnime("airing");

      setState(() {
        _topAnime = topResults;
        _favoriteAnime = favoriteResults;
        _airingAnime = airingResults;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar(e.toString());
    }
  }

  void _searchAnime() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _isSearching = true;
    });

    try {
      final results = await apiService.searchAnime(_searchController.text);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar(e.toString());
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for anime...',
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search, color: AppColors.buttonSecondaryColor),
          suffixIcon: IconButton(
            icon: const Icon(Icons.send, color: AppColors.buttonSecondaryColor),
            onPressed: _searchAnime,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
        ),
        onChanged: (value) => _searchAnime(),
      ),
    );
  }

  Widget _buildHorizontalAnimeList(String title, List<Anime> animeList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondaryColor,
                ),
              ),
              TextButton(
                onPressed: () {

                },
                child: const Text('See All', style: TextStyle(color: AppColors.primaryColor),),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 275,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: animeList.length,

            itemBuilder: (context, index) {
              final anime = animeList[index];
              return _buildVerticalAnimeCard(anime);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalAnimeCard(Anime anime) {
    return FadeInRight(
      child: Container(
        width: 150,

        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnimeDetailPage(malId: anime.malId),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: anime.imageURL,
                  height: 200,
                  width: 150,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: SpinKitWave(
                      color: AppColors.primaryColor,
                      size: 30.0,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                anime.titleEnglish,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondaryColor
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    anime.score.toString(),
                    style: const TextStyle(fontSize: 12,color: AppColors.textSecondaryColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: SpinKitFoldingCube(
          color: AppColors.primaryColor,
        ),
      );
    }

    if (_isSearching) {
      return _searchResults.isEmpty
          ? _buildEmptyState()
          : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
            final anime = _searchResults[index];
            return SearchAnimeCard(anime: anime,);
                    },
                  ),
          );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHorizontalAnimeList('Top Anime', _topAnime),
          _buildHorizontalAnimeList('Top Favorite Anime', _favoriteAnime),
          _buildHorizontalAnimeList('Top Airing Anime', _airingAnime),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Icon(
                Icons.search_off,
                color: Colors.white,
                size: 64,
              )),
          Text(
            'Search not found',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondaryColor,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Start exploring amazing anime!',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Explore Anime',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondaryColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSearchBar(),
          ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }
}