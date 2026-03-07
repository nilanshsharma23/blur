import 'package:blur/classes/profile_object.dart';

class PostObject {
  final bool anonymous;
  final String uid;
  final ProfileObject? profileObject;
  final DateTime createdAt;
  final String content;

  PostObject({
    required this.anonymous,
    required this.uid,
    this.profileObject,
    required this.createdAt,
    required this.content,
  });
}
