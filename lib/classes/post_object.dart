class PostObject {
  final bool anonymous;
  final String uid;
  final String userId;
  final DateTime createdAt;
  final String content;

  PostObject({
    required this.anonymous,
    required this.uid,
    required this.userId,
    required this.createdAt,
    required this.content,
  });
}
