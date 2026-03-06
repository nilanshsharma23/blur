import 'package:blur/pages/home_page.dart';
import 'package:blur/pages/profile_setup_page.dart';
import 'package:blur/pages/sign_in_page.dart';
import 'package:blur/pages/sign_up_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/profile-setup',
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
