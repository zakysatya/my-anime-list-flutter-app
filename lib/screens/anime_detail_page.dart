import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/anime.dart';
import '../models/anime_character.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';
import '../widgets/character_list_view.dart';
import '../widgets/read_more_text.dart';

class AnimeDetailPage extends StatefulWidget {
  final int malId;

  const AnimeDetailPage({Key? key, required this.malId}) : super(key: key);

  @override
  _AnimeDetailPageState createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  final ApiService _apiService = ApiService();
  Anime? _anime;
  List<AnimeCharacter> _characters = [];
  YoutubePlayerController? _trailerController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnimeDetails();
  }

  Future<void> _fetchAnimeDetails() async {
    try {
      final animeData = await _apiService.getAnimeById(widget.malId);
      final characterData = await _apiService.getAnimeCharacters(widget.malId);

      String? videoId = YoutubePlayer.convertUrlToId(animeData.trailerURL) ?? 'dQw4w9WgXcQ';

      _trailerController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,

        ),
      );

      setState(() {
        _anime = animeData;
        _characters = characterData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, Color? iconColor,
      {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, color: iconColor ?? AppColors.buttonSecondaryColor, size: 32),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.openSans(color: AppColors.textPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondaryColor,
      body: _isLoading
          ? const Center(
        child: SpinKitFoldingCube(
          color: AppColors.primaryColor,
        ),
      )
          : _buildAnimeDetails(),
    );
  }

  Widget _buildAnimeDetails() {
    if (_anime == null) return const SizedBox.shrink();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 500.0,
          collapsedHeight: 60,
          floating: false,
          pinned: true,
          stretch: true,
          backgroundColor: AppColors.backgroundColor,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            collapseMode: CollapseMode.parallax,
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _anime!.titleEnglish,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            background: Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl:_anime!.imageURL,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator()),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.3),
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.0),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.1),
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.0),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Trailer Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                  child: _buildTrailerSection()),

              // Anime Information
              const SizedBox(height: 16),
              Text(
                'About ${_anime!.title}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondaryColor,
                ),
              ),
              
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
                ),
                  child: ReadMoreText(text: _anime!.synopsis)),

              // Detailed Information
              const SizedBox(height: 16),
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: [

                  _buildDetailCard('Type', _anime!.type,AppColors.buttonSecondaryColor, icon: Icons.category),
                  _buildDetailCard('Status', _anime!.status, AppColors.buttonSecondaryColor, icon: Icons.info),
                  _buildDetailCard('Score', _anime!.score.toString(), Colors.orange ,icon: Icons.star),
                  _buildDetailCard('Episodes', _anime!.episodes.toString(), AppColors.buttonSecondaryColor, icon: Icons.play_arrow),
                  _buildDetailCard('Aired', _anime!.date,AppColors.buttonSecondaryColor, icon: Icons.calendar_today),
                  _buildDetailCard('Duration', _anime!.duration,AppColors.buttonSecondaryColor, icon: Icons.timer),
                  _buildDetailCard('Popularity', "#${_anime!.popularity}" ,Colors.red, icon: Icons.local_fire_department),
                  _buildDetailCard('Rank', "#${_anime!.rank}" ,Colors.red, icon: Icons.flag_rounded),
                ],
              ),

              // Genres and Themes
              const SizedBox(height: 16),
              _anime!.genres.isNotEmpty ? _buildChipSection('Genres', _anime!.genres): const SizedBox(),
              _anime!.themes.isNotEmpty ? _buildChipSection('Themes', _anime!.themes) : const SizedBox(),

              // Characters
              const SizedBox(height: 16),
              const Text(
                'Characters',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 16),
              CharacterListView(characters: _characters),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildTrailerSection() {
    return _trailerController != null
        ? YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _trailerController!,
        showVideoProgressIndicator: true,
        bottomActions: const [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
          RemainingDuration(),
          FullScreenButton(),
        ],
      ),
      builder: (context, player) => player,
    )
        : const SizedBox.shrink();
  }

  Widget _buildChipSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return Chip(
              label: Text(item),
              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
              labelStyle: const TextStyle(color: AppColors.textPrimaryColor, fontWeight: FontWeight.bold),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _trailerController?.dispose();
    super.dispose();
  }
}