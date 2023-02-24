import 'dart:convert';

import 'package:cpscom/src/constants/api_config.dart';
import 'package:cpscom/src/presentation/authenticate/otpScreen.dart';
import 'package:cpscom/src/utils/messgaetoast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
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
            'Forgot Password',
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
                  height: 600,
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
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.height * 0.50,
                          alignment: Alignment.center,
                          child: field(
                              size, "Email", Icons.mail, _emailController),
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
                                onTap: () {
                                  if (_emailController.text.isNotEmpty) {
                                    sendEmailData(
                                      context,
                                      _emailController.text,
                                    );
                                  } else {
                                    if (kDebugMode) {
                                      showToastMessage(
                                          'Please fill form correctly');
                                    }
                                  }
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
                        SizedBox(
                          height: size.height / 50,
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

  Widget field(
      Size size, String hintText, IconData icon, TextEditingController cont) {
    return SizedBox(
      height: size.height / 15,
      width: size.width / 1.2,
      child: TextField(
        controller: cont,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black),
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

  sendEmailData(
    BuildContext context,
    String emailValue,
  ) async {
    setState(() => isLoading = true);
    Future.delayed(
      const Duration(seconds: 2),
      () => setState(() => isLoading = false),
    );
    Map data = {'email': emailValue};
    http.Response response =
        await http.post(Uri.parse(BaseApi.forgotPasswordApi), body: data);
    var jsonResponse = json.decode(response.body);
    debugPrint("Statuscode>>>${response.statusCode}");
    String resStatus = jsonResponse['status'].toString();
    var resMsg = jsonResponse['message'];
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      showToastMessage(resMsg);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(
            useEmail: emailValue,
          ),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showToastMessage(resMsg);
    }
  }
}
