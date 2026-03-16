import 'package:blur/classes/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> deleteAccount() async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  final circleData =
      (await db
              .collection('circles')
              .where('moderators', arrayContains: auth.currentUser!.uid)
              .get())
          .docs;

  for (var circle in circleData) {
    await db.collection('circles').doc(circle.data()['code']).update({
      'moderators': FieldValue.arrayRemove([auth.currentUser!.uid]),
    });
  }

  Globals.currentProfile = null;

  await auth.currentUser?.delete();
}
