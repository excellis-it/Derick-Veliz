import 'package:cpscom/src/constants/app_colors.dart';
import 'package:cpscom/src/presentation/authenticate/loginScree.dart';
import 'package:cpscom/src/presentation/group_chat/group_chat_screen.dart';
import 'package:cpscom/src/routing/routing_config.dart';
import 'package:cpscom/src/utils/device_size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () async {
    //   final FirebaseAuth _auth = FirebaseAuth.instance;
    //   print(_auth.currentUser);
    //   if (_auth.currentUser != null) {
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (_) => const GroupChatHomeScreen()));
    //   } else {
    //     Navigator.of(context).pushNamedAndRemoveUntil(
    //       signInScreen,
    //       (Route<dynamic> route) => false,
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    DeviceSizeConfig deviceSizeConfig = DeviceSizeConfig(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 16.0,
              bottom: 16.0,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/group_bg.png"),
                  fit: BoxFit.cover),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: <double>[
                  0.25,
                  0.65,
                  0.75,
                ],
                colors: <Color>[
                  colorBackgroundGradientStart,
                  colorBackgroundGradientEnd,
                  Colors.grey,
                ],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 75.0,
                ),
                Image.asset(
                  'assets/images/group.png',
                  height: deviceSizeConfig.blockSizeVertical * 40,
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 0.8,
            snap: true,
            builder: (
              BuildContext context,
              ScrollController scrollController,
            ) {
              return Container(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  bottom: 16.0,
                ),
                decoration: const BoxDecoration(
                  //color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  children: <Widget>[
                    const SizedBox(height: 100),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24.0, right: 24.0, top: 5.0),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur Nibh quisque amet',
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 16.0,
                              color: const Color(0XFF000000),
                            ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                        bottom: 0.0,
                      ),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur Nibh quisque amet',
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              fontSize: 13.0,
                              color: Colors.grey[700],
                            ),
                      ),
                    ),
                    //
                    const SizedBox(
                      height: 20.0,
                    ),
                    MaterialButton(
                      padding: const EdgeInsets.all(8),
                      textColor: Colors.white,
                      splashColor: Colors.white,
                      elevation: 8.0,

                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(0, 192, 255, 1),
                              Color.fromRGBO(85, 88, 255, 1)
                            ])

                            // image: DecorationImage(
                            //     image: AssetImage('assets/images/rectangle.png'),
                            //     fit: BoxFit.cover),
                            ),
                        child: const Padding(
                          padding: EdgeInsets.all(30),
                          child: Text(
                            "Get Started",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      // ),
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          authenticationScreen,
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
