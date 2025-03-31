class UserProfile {
  final String username;
  final String bio;
  final String profileImage;

  UserProfile({
    required this.username,
    required this.bio,
    required this.profileImage,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username:
          json['username'] ??
          'No username', // Талбар байхгүй бол 'No username' гэдэг утга оруулна
      bio: json['bio'] ?? 'No bio',
      profileImage:
          json['profile_image'] ?? '', // Хэрэв зураг байвал тухайн замыг авна
    );
  }
}
