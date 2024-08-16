import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_contact/Feature/EditProfileScreen/edit_profile.dart';
import 'package:my_contact/Feature/HomeScreen/home_screen.dart';
import 'package:my_contact/Feature/HomeScreen/model/view_model_api_profile.dart';
import 'package:my_contact/Feature/SendEmailScreen/send_email.dart';

class Routes {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return HomeScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'edit_profile',
            builder: (BuildContext context, GoRouterState state) {
              final profile = state.extra as ViewModelApiProfile;
              return EditProfileUI(profile: profile);
            },
          ),
          GoRoute(
            path: 'send_email',
            builder: (BuildContext context, GoRouterState state) {
              final data = state.extra! as Map<String, dynamic>;
              return SendEmailUI(
                favorite: data['isFavorite'],
                profile: data['profile'],
              );
            },
          ),
        ],
      ),
    ],
  );
}
