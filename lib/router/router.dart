import 'package:college_notees/arguments/arguments.dart';

import 'package:college_notees/screens/activity_list.dart';
import 'package:college_notees/screens/edit_user_info.dart';
import 'package:college_notees/screens/form.dart';
import 'package:college_notees/screens/home_page.dart';
import 'package:college_notees/screens/profile_page.dart';
import 'package:college_notees/widgets/auth_check.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final routers = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthCheck(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/activity-list/:disciplina/:userId',
      builder: (context, state) => ActivityList(
          title: state.params['disciplina']!, userId: state.params['userId']!),
    ),
    GoRoute(
      path: '/profile/:userId',
      builder: (context, state) => ProfilePage(userId: state.params['userId']!),
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
    GoRoute(
      path: '/form',
      builder: (context, state) {
        ActivityArguments activityInfo = state.extra as ActivityArguments;

        return Form(
            title: activityInfo.title,
            content: activityInfo.content,
            date: activityInfo.date,
            docRef: activityInfo.docRef,
            disciplina: activityInfo.disciplina,
            isEditing: activityInfo.isEditing);
      },
    ),
  ],
);
