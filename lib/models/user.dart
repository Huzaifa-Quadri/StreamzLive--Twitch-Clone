class User {
  final String userId;
  final String username;
  final String email;

  User({required this.userId, required this.username, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'uid': userId,
      'username': username,
      'email': email,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
