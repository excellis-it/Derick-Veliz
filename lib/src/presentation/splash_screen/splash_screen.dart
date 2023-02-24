import 'package:cpscom/src/routing/routing_config.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

//
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          onboardingScreen,
          (Route<dynamic> route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Image.asset(
              "assets/images/header_icon.png",
            ),
            Column(
              children: const [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "CPSCOM",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.lock,
                  color: Colors.orange,
                  size: 50,
                )
              ],
            )
          ],
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    ));

    // Material(
    //   child: Container(
    //     decoration: const BoxDecoration(
    //       gradient: LinearGradient(
    //         begin: Alignment.topCenter,
    //         end: Alignment.bottomCenter,
    //         colors: <Color>[
    //           colorBackgroundGradientStart,
    //           colorBackgroundGradientEnd,
    //         ],
    //         tileMode: TileMode.mirror,
    //       ),
    //     ),
    //     child: Image.asset('assets/images/splash.png',
    //         height: MediaQuery.of(context).size.height,
    //         width: MediaQuery.of(context).size.width,
    //         fit: BoxFit.cover),
    //   ),
    // );
  }
}
