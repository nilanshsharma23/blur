import 'package:blur/pages/home_page.dart';
import 'package:blur/pages/profile_setup_page.dart';
import 'package:blur/pages/sign_in_page.dart';
import 'package:blur/pages/sign_up_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/sign-up',
  redirect: (context, state) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    if (FirebaseAuth.instance.currentUser != null) {
      var data = await db
          .collection('profiles')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      return data.exists ? '/' : '/profile-setup';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomePage()),
    GoRoute(path: '/sign-up', builder: (context, state) => SignUpPage()),
    GoRoute(path: '/sign-in', builder: (context, state) => SignInPage()),
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => ProfileSetupPage(),
    ),
  ],
);
