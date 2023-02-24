import 'dart:convert';

import 'package:cpscom/src/constants/api_config.dart';
import 'package:cpscom/src/presentation/authenticate/loginScree.dart';
import 'package:cpscom/src/presentation/group_chat/group_chat_screen.dart';
import 'package:cpscom/src/routing/routing_config.dart';
import 'package:cpscom/src/utils/messgaetoast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Methods.dart';
import 'createAccount.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  var useEmail;
  ChangePassword({super.key, required this.useEmail});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
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
            'Change Password',
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
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.height * 0.50,
                            alignment: Alignment.center,
                            child:
                                field(size, "Password", Icons.lock, _password),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.height * 0.50,
                            alignment: Alignment.center,
                            child: field(size, "Confirm Password", Icons.lock,
                                _confirmpassword),
                          ),
                        ),
                        SizedBox(
                          height: size.height / 40,
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
                                  if (_password.text.isNotEmpty &&
                                      _confirmpassword.text.isNotEmpty) {
                                    // setState(() {
                                    //   isLoading = true;
                                    // });
                                    passwordChangeData(context, _password.text,
                                        _confirmpassword.text);
                                  } else {
                                    if (kDebugMode) {
                                      //print("Please fill form correctly");
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
                          height: size.height / 20,
                        ),
                      ],
                    ), //Column
                  ), //Padding
                ),
                //SizedBox
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

  // void passwordChangeData(BuildContext context, String text, String text2) {}
  Future<void> passwordChangeData(
      BuildContext context, String passValue, String newPassValue) async {
    if (passValue == '' || newPassValue == '') {
      showToastMessage("Enter valid otp");
    } else {
      setState(() => isLoading = true);
      Future.delayed(
        const Duration(seconds: 2),
        () => setState(() => isLoading = false),
      );
      Map data = {
        'email': widget.useEmail,
        'password': passValue,
        'confirm_password': newPassValue
      };
      http.Response response =
          await http.post(Uri.parse(BaseApi.changePasswordApi), body: data);
      var jsonResponse = json.decode(response.body);
      print(response.body);
      String resStatus = jsonResponse['status'].toString();
      if (kDebugMode) {
        print("changePasswordApi>>>${response.statusCode}");
      }
      var resMsg = jsonResponse['message'];
      if (response.statusCode == 200) {
        showToastMessage(resMsg);
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      } else if (response.statusCode == 401) {
        showToastMessage("The confirm password and password must match.");
      } else {
        showToastMessage(resMsg);
      }
    }
  }
}
