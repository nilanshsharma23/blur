import 'package:blur/classes/circle_object.dart';
import 'package:blur/classes/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<CircleObject>> getCircles() async {
  List<CircleObject> output = [];
  FirebaseFirestore db = FirebaseFirestore.instance;

  for (var code in Globals.currentProfile!.circles) {
    var data =
        (await db.collection('circles').doc(code).get()).data()
            as Map<String, dynamic>;

    output.add(CircleObject(code: code, name: data['name']));
  }

  return output;
}
