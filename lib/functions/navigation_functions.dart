import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void onDestinationSelected(BuildContext context, {required int index}) {
  switch (index) {
    case 0:
      GoRouter.of(context).go('/');
      break;
    case 1:
      GoRouter.of(context).go('/add-blurt');
      break;
    case 2:
      GoRouter.of(context).go('/my-circles');
      break;
    case 3:
      GoRouter.of(context).go('/profile');
      break;
    case 4:
      GoRouter.of(context).go('/settings');
      break;
    default:
  }
}

int calculateSelectedIndex(BuildContext context) {
  final String location = GoRouterState.of(context).uri.path;

  if (location == '/add-blurt') {
    return 1;
  } else if (location == '/my-circles') {
    return 2;
  } else if (location == '/profile') {
    return 3;
  } else if (location == '/settings') {
    return 4;
  } else {
    return 0;
  }
}
