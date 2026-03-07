import 'package:blur/classes/globals.dart';
import 'package:blur/classes/profile_object.dart';
import 'package:blur/pages/create_post_page.dart';
import 'package:blur/pages/home_page.dart';
import 'package:blur/pages/profile_page.dart';
import 'package:blur/pages/profile_setup_page.dart';
import 'package:blur/pages/sign_in_page.dart';
import 'package:blur/pages/sign_up_page.dart';
import 'package:blur/widgets/navigation/navigation_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

final router = GoRouter(
  initialLocation: '/sign-up',
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => SignUpPage(),
      redirect: (context, state) async {
        FirebaseFirestore db = FirebaseFirestore.instance;

        if (FirebaseAuth.instance.currentUser != null) {
          var doc = await db
              .collection('profiles')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();

          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          List<String> circles = [];

          for (var i = 0; i < data['circles'].length; i++) {
            circles.add(data['circles'][i]);
          }

          if (doc.exists) {
            Globals.currentProfile = ProfileObject(
              name: data['name'],
              handle: data['handle'],
              uid: doc.id,
              circles: circles,
            );
          }

          return doc.exists ? '/' : '/profile-setup';
        }

        return null;
      },
    ),
    GoRoute(path: '/sign-in', builder: (context, state) => SignInPage()),
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => ProfileSetupPage(),
    ),
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) {
        return NavigationScaffold(child: child);
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => HomePage()),
        GoRoute(
          path: '/create-post',
          builder: (context, state) => CreatePostPage(),
        ),
        GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),
      ],
    ),
  ],
);
