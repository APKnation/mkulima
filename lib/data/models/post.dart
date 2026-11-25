class CommunityComment {
  CommunityComment({
    required this.id,
    required this.author,
    required this.role,
    required this.timeAgo,
    required this.text,
    this.isExpert = false,
  });

  final String id;
  final String author;
  final String role;
  final String timeAgo;
  final String text;
  final bool isExpert;
}

class CommunityPost {
  CommunityPost({
    required this.id,
    required this.author,
    required this.role,
    required this.location,
    required this.timeAgo,
    required this.content,
    required this.categoryLabel,
    required this.type,
    this.imageAsset,
    this.likes = 0,
    this.liked = false,
    this.comments = const [],
    this.isExpert = false,
  });

  final String id;
  final String author;
  final String role;
  final String location;
  final String timeAgo;
  final String content;
  final String categoryLabel;

  /// `swali`, `ushauri` or `mafanikio`.
  final String type;
  final String? imageAsset;
  final int likes;
  final bool liked;
  final List<CommunityComment> comments;
  final bool isExpert;

  String get typeLabel => switch (type) {
        'swali' => 'Swali',
        'mafanikio' => 'Mafanikio',
        _ => 'Ushauri',
      };

  CommunityPost copyWith({
    int? likes,
    bool? liked,
    List<CommunityComment>? comments,
  }) {
    return CommunityPost(
      id: id,
      author: author,
      role: role,
      location: location,
      timeAgo: timeAgo,
      content: content,
      categoryLabel: categoryLabel,
      type: type,
      imageAsset: imageAsset,
      likes: likes ?? this.likes,
      liked: liked ?? this.liked,
      comments: comments ?? this.comments,
      isExpert: isExpert,
    );
  }
}
