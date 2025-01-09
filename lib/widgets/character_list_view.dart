import 'package:flutter/material.dart';
import 'package:myanimelist/widgets/character_card.dart';
import '../utils/app_colors.dart';

class CharacterListView extends StatelessWidget {
  final List<dynamic> characters;

  const CharacterListView({super.key, required this.characters});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return CharacterCard(
                characterName: character.name,
                characterImageURL: character.imageURL,
                role: character.role,
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => AllCharactersPage(characters: characters),
              //   ),
              // );
            },
            child: const Text(
              "View All",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}