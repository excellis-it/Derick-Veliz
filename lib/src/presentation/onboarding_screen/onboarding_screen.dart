// ignore_for_file: unnecessary_const

import 'dart:async';
import 'dart:convert';

import 'package:cpscom/src/constants/api_config.dart';
import 'package:cpscom/src/model/cmsModel.dart';
import 'package:cpscom/src/routing/routing_config.dart';
import 'package:cpscom/src/utils/device_size_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  var cmsTitle = '';
  var cmsDescripation = '';
  var cmsImage;
  late Future<CmsModel> cmsGetStarted1;
  @override
  void initState() {
    super.initState();
    cmsGetStarted();
  }

  cmsGetStarted() async {
    Map data = {'is_panel': 'admin'};

    http.Response response =
        await http.post(Uri.parse(BaseApi.cmsGetStarted), body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      //var resMsg = jsonResponse['message'];
      var cmsData = jsonResponse['data']['cms'];
      setState(() {
        cmsTitle = cmsData['title'].toString();
        cmsDescripation = cmsData['description'].toString();
        cmsImage = cmsData['image'].toString();
      });
      // cmsTitle = cmsData['title'].toString();
      // cmsDescripation = cmsData['description'].toString();
      // cmsImage = cmsData['image'].toString();
    } else {}
  }

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    DeviceSizeConfig deviceSizeConfig = DeviceSizeConfig(context);
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: const DecorationImage(
              image: const AssetImage("assets/images/group_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          /** Card Widget **/
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            shadowColor: Colors.black,
            color: Colors.white,
            child: SizedBox(
              width: 700,
              height: 600,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        cmsImage == null
                            ? Image.asset(
                                'assets/images/group.png',
                                height: deviceSizeConfig.blockSizeVertical * 40,
                              )
                            : Image(
                                image: NetworkImage(
                                  // ignore: prefer_interpolation_to_compose_strings
                                  'https://excellis.co.in/derick-veliz-admin/public/storage/' +
                                      cmsImage,
                                ),
                                height: deviceSizeConfig.blockSizeVertical * 40,
                                //height: mediaQuery.height * 0.3,
                                // width: MediaQuery.of(context).size.height * 3.5,
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ), //SizedBox
                    Text(
                      '$cmsTitle',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0XFF000000),
                        //color: Colors.green[900],
                        fontWeight: FontWeight.w500,
                      ), //Textstyle
                    ), //Text
                    const SizedBox(
                      height: 10,
                    ), //SizedBox
                    Text(
                      '$cmsDescripation',
                      maxLines: 4,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ), //Textstyle
                    ), //Text
                    const SizedBox(
                      height: 30,
                    ), //SizedBox
                    MaterialButton(
                      textColor: Colors.white,
                      splashColor: Colors.white,
                      elevation: 8.0,

                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.height * 0.30,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(0, 192, 255, 1),
                              Color.fromRGBO(85, 88, 255, 1)
                            ])),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 11.0),
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
                ), //Column
              ), //Padding
            ), //SizedBox
          ), //Card
        ),
      ],
    ));
  }
}
