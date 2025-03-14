class AuthorModel {
  final int id;
  final String name;
  final String bio;
  final String profilePicture;
  final double popularity;
  final List<String> booksWritten; // List of book IDs

  AuthorModel({
    required this.id,
    required this.name,
    required this.bio,
    required this.popularity,
    required this.profilePicture,
    required this.booksWritten,
  });

  // Convert Supabase Map to AuthorModel
  factory AuthorModel.fromMap(Map<String, dynamic> map) {
    return AuthorModel(
      id: map['id'] as int,
      name: map['name'] as String,
      bio: map['bio'] as String,
      popularity: map['popularity'],
      profilePicture: map['profilePicture'] as String,
      booksWritten: (map['booksWritten'] as List<dynamic>).cast<String>(),
    );
  }

  // Convert AuthorModel to Map (For Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'popularity': popularity,
      'profilePicture': profilePicture,
      'booksWritten': booksWritten,
    };
  }
}
