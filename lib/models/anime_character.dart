class AnimeCharacter {
  int malId;
  String name;
  String imageURL;
  String role;

  AnimeCharacter({
    required this.malId,
    required this.name,
    required this.imageURL,
    required this.role,

  });

  static AnimeCharacter fromMap(Map<String, dynamic> jsonData) {
    return AnimeCharacter(
      malId: jsonData['character']?['mal_id'] ?? 0,
      name: jsonData['character']?['name'] ?? '',
      imageURL: jsonData['character']?['images']?['jpg']?['image_url'] ?? '',
      role: jsonData['role'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'malId': malId,
      'name': name,
      'imageURL': imageURL,
      'role': role,

    };
  }
}
