import 'package:flutter/material.dart';
import 'package:management/features/auth/pages/otp_pages.dart';

import '../../features/auth/pages/login.dart';
import '../../features/onboarding/pages/onboarding.dart';
import '../../features/todo/pages/homepage.dart';

class Routes {
  static const String onBoarding = "onBoarding";
  static const String home = "home";
  static const String login = "login";
  static const String signUp = "signUp";
  static const String forgotPassword = "forgotPassword";
  static const String otp = "otp";
  static const String profile = "profile";
  static const String addTask = "addTask";
  static const String editTask = "editTask";
  static const String splash = "splash";
  static const String settings = "settings";
  static const String about = "about";
  static const String privacyPolicy = "privacyPolicy";
  static const String termsAndConditions = "termsAndConditions";

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onBoarding:
        return MaterialPageRoute(builder: (_) => const OnBoarding());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case otp:
        final Map args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => OTPPage(
                  phone: args['phone'],
                  verificationId: args['verificationId'],
                ));

      default:
    }

    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      ),
    );
  }
}
