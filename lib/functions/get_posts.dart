import 'package:blur/classes/post_object.dart';
import 'package:blur/classes/profile_object.dart';
import 'package:blur/functions/get_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<PostObject>> getPosts(String circleCode) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<PostObject> output = [];
  List<ProfileObject> profileCache = [];

  await db
      .collection(circleCode)
      .orderBy('created_at', descending: true)
      .limit(10)
      .get()
      .then((value) async {
        for (var docSnapshot in value.docs) {
          var data = docSnapshot.data();

          ProfileObject? profileObject;

          if (!data['anonymous']) {
            try {
              profileObject = profileCache.firstWhere(
                (element) => element.uid == data['user_id'],
              );
            } catch (e) {
              ProfileObject newProfileObject = await getProfile(
                data['user_id'],
              );
              profileCache.add(newProfileObject);
              profileObject = newProfileObject;
            }
          }

          output.add(
            PostObject(
              anonymous: data['anonymous'],
              uid: docSnapshot.id,
              createdAt: DateTime.fromMillisecondsSinceEpoch(
                data['created_at'].seconds * 1000,
              ),
              content: data['content'],
              profileObject: profileObject,
            ),
          );
        }
      });

  return output;
}
