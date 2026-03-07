import 'package:blur/classes/profile_object.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<ProfileObject> getProfile(String uid) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  var doc = await db.collection('profiles').doc(uid).get();
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  List<String> circles = [];

  for (var i = 0; i < data['circles'].length; i++) {
    circles.add(data['circles'][i]);
  }

  return ProfileObject(
    name: data['name'],
    handle: data['handle'],
    uid: uid,
    circles: circles,
  );
}
