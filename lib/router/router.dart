import 'package:college_notees/arguments/arguments.dart';

import 'package:college_notees/screens/edit_user_info.dart';
import 'package:college_notees/screens/not_found_page.dart';
import 'package:college_notees/widgets/auth_check.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// GoRouter configuration
final routers = GoRouter(
  initialLocation: '/',
  errorPageBuilder: (BuildContext context, GoRouterState state) =>
      const MaterialPage(child: NotFoundPage()),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthCheck(),
    ),
    GoRoute(
      path: '/profile/:userId/edit/:info',
      builder: (context, state) {
        EditInfoUserArguments editInfoUser =
            state.extra as EditInfoUserArguments;

        return EditInfoUser(
            title: editInfoUser.title,
            content: editInfoUser.content,
            label: editInfoUser.label,
            hint: editInfoUser.hint,
            validator: editInfoUser.validator,
            docId: editInfoUser.docId,
            dbName: editInfoUser.dbName);
      },
    ),
  ],
);
