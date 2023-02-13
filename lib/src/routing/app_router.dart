// ignore_for_file: always_specify_types
import 'package:cpscom/src/presentation/authenticate/autheticate.dart';
import 'package:cpscom/src/presentation/authenticate/loginScree.dart';
import 'package:cpscom/src/presentation/onboarding_screen/onboarding_screen.dart';
import 'package:cpscom/src/routing/routing_config.dart';
import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';

Route<dynamic> generateRoutes(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case splashScreen:
      return MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );
    case onboardingScreen:
      return MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      );
    case authenticationScreen:
      return MaterialPageRoute(
        builder: (context) => Authenticate(),
      );

    case signInScreen:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );

    default:
      return MaterialPageRoute(
        builder: (BuildContext context) => Scaffold(
          body: Center(
            child: Text(
              'No route defined for ${routeSettings.name}',
            ),
          ),
        ),
      );
  }
}
