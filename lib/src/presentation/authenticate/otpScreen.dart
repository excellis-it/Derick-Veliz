import 'dart:convert';

import 'package:cpscom/src/constants/api_config.dart';
import 'package:cpscom/src/presentation/authenticate/changePassword.dart';
import 'package:cpscom/src/utils/messgaetoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OtpScreen extends StatefulWidget {
  var useEmail;
  OtpScreen({super.key, this.useEmail});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _key = GlobalKey<FormState>();
  //final TextEditingController _email = TextEditingController();

  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'OTP Verification',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: MediaQuery.of(context).size.height / 50,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/group_bg.png"),
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
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                shadowColor: Colors.black,
                color: Colors.white,
                child: SizedBox(
                  width: 700,
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 20.0,
                            ),
                            Image.asset(
                              'assets/images/header_icon.png',
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            const Text(
                              "CPSCOM",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // const Padding(
                            //   padding: EdgeInsets.only(
                            //     top: 10.0,
                            //     bottom: 10.0,
                            //     left: 40,
                            //     right: 40.0,
                            //   ),
                            //   child: Text(
                            //     'Verify Your Account',
                            //     maxLines: 2,
                            //     textAlign: TextAlign.center,
                            //     style: TextStyle(
                            //       fontSize: 22.0,
                            //       color: Color(0xff1E1E1E),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                              //MediaQuery.height * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.0),
                              // mediaQuery.width * 0.0),
                              child: const Center(
                                child: Text(
                                  'Please enter the 4 digit code sent to your email address ',
                                  // maxLines: 2,
                                  textAlign: TextAlign.center,
                                  //style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.height * 0.50,
                          alignment: Alignment.center,
                          child:
                              field(size, "One Time Password", otpController),
                        ),
                        SizedBox(
                          height: size.height / 20,
                        ),
                        isLoading
                            ? Center(
                                child: SizedBox(
                                  height: size.height / 20,
                                  width: size.height / 20,
                                  child: const CircularProgressIndicator(),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  verifyOtpData(
                                    context,
                                    otpController.text,
                                  );
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width:
                                      MediaQuery.of(context).size.height * 0.30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    gradient: const LinearGradient(
                                      begin: Alignment(-0.95, 0.0),
                                      end: Alignment(1.0, 0.0),
                                      colors: [
                                        Color(0xff667eea),
                                        Color(0xff64b6ff)
                                      ],
                                      stops: [0.0, 1.0],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontSize: 20,
                                        //fontWeight: FontWeight.bold,
                                        color: Color(0xffffffff),
                                        letterSpacing: -0.3858822937011719,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Not Received?',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                resendOtp(context);
                              },
                              child: Text(
                                'RESEND',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                              ),
                            ),
                          ],
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

  Widget field(Size size, String hintText, TextEditingController cont) {
    return SizedBox(
      height: size.height / 15,
      width: size.width / 1.2,
      child: TextField(
        controller: cont,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          hintStyle: const TextStyle(
            color: Colors.black,
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 237, 238, 241),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  void verifyOtpData(BuildContext context, String otpvVlaue) async {
    if (otpvVlaue == '') {
      showToastMessage("Enter valid otp");
    } else {
      // var userEmail = widget.useEmail;
      setState(() => isLoading = true);
      Future.delayed(
        const Duration(seconds: 1),
        () => setState(() => isLoading = false),
      );
      Map data = {'email': widget.useEmail, 'otp': otpvVlaue};
      http.Response response =
          await http.post(Uri.parse(BaseApi.otpVerify), body: data);
      var jsonResponse = json.decode(response.body);
      String resStatus = jsonResponse['status'].toString();
      var resMsg = jsonResponse['message'];
      if (response.statusCode == 200) {
        showToastMessage(resMsg);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangePassword(
              useEmail: widget.useEmail,
            ),
          ),
        );
      } else {
        showToastMessage(resMsg);
      }
    }
  }

  resendOtp(
    BuildContext context,
  ) async {
    Map data = {'email': widget.useEmail};
    http.Response response =
        await http.post(Uri.parse(BaseApi.forgotPasswordApi), body: data);
    var jsonResponse = json.decode(response.body);
    //debugPrint("Statuscode>>>${response.statusCode}");
    String resStatus = jsonResponse['status'].toString();
    // ignore: always_specify_types
    var resMsg = jsonResponse['message'];
    if (response.statusCode == 201) {
      if (resStatus == '1') {
        showToastMessage(resMsg);
      } else {
        showToastMessage(resMsg);
      }
    } else {
      showToastMessage("Error! Input data is missing");
    }
  }
}
