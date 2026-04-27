class User {
  final String id;
  final String name;
  final String email;
  final int totalXP;
  final int level;
  final int currentStreak;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.totalXP,
    required this.level,
    required this.currentStreak,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      totalXP: json['totalXP'] ?? 0,
      level: json['level'] ?? 1,
      currentStreak: json['currentStreak'] ?? 0,
    );
  }
}
