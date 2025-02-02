class LiveStream {
  final String title;
  final String userId;
  final String image;
  final String username;
  final startedAt;
  final int
      viewers; //for now viewers is just a count but we can convert it into list containin uid of all viewers
  final String channelId;

  LiveStream({
    required this.title,
    required this.image,
    required this.userId,
    required this.username,
    required this.viewers,
    required this.channelId,
    required this.startedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'userId': userId,
      'username': username,
      'viewers': viewers,
      'channelId': channelId,
      'startedAt': startedAt,
    };
  }

  factory LiveStream.fromMap(Map<String, dynamic> map) {
    return LiveStream(
      title: map['title'] ?? '',
      image: map['image'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      viewers: map['viewers']?.toInt() ?? 0,
      channelId: map['channelId'] ?? '',
      startedAt: map['startedAt'] ?? '',
    );
  }
}
