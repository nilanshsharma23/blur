import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void onDestinationSelected(BuildContext context, {required int index}) {
  switch (index) {
    case 0:
      GoRouter.of(context).go('/');
      break;
    case 1:
      GoRouter.of(context).go('/create-post');
      break;
    case 2:
      GoRouter.of(context).go('/profile');
      break;
    default:
  }
}

int calculateSelectedIndex(BuildContext context) {
  final String location = GoRouterState.of(context).uri.path;

  if (location == '/create-post') {
    return 1;
  } else if (location == '/profile') {
    return 2;
  } else {
    return 0;
  }
}
