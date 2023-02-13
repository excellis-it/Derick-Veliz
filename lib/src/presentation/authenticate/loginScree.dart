import 'package:cpscom/src/presentation/group_chat/group_chat_screen.dart';
import 'package:cpscom/src/utils/messgaetoast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Methods.dart';
import 'createAccount.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/group_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  height: size.height / 20,
                  width: size.height / 20,
                  child: const CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 150.0),
                      child: SizedBox(
                        // height: deviceSizeConfig.blockSizeVertical * 40,
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/header_icon.png',
                          height: 50,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width / 1.1,
                      child: const Text(
                        "CPSCOM",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 10,
                    ),
                    Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(size, "email", Icons.account_box, _email),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: field(size, "password", Icons.lock, _password),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 40,
                    ),
                    customButton(size),
                    SizedBox(
                      height: size.height / 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Do not have an account?',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => CreateAccount())),
                          child: const Text(
                            'SIGN UP',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff64b6ff),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height / 1,
                    ),
                  ],
                ),
              ), /* add child content here */
      ),

      /* add child content here */
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          logIn(_email.text, _password.text).then((user) {
            if (user != null) {
              if (kDebugMode) {
                //print("Login Sucessfull");
                print("userData" + user.toString());
                showToastMessage('Login Sucessfull');
              }
              setState(() {
                isLoading = false;
              });
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (_) => HomeScreen()));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const GroupChatHomeScreen()));
            } else {
              if (kDebugMode) {
                print(user);
                showToastMessage(
                    'There is no user record corresponding to this identifier. The user may have been deleted.');
              }
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          if (kDebugMode) {
            //print("Please fill form correctly");
            showToastMessage('Please fill form correctly');
          }
        }
      },
      child: Container(
        height: size.height / 15,
        width: size.width / 1.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: const LinearGradient(
            begin: Alignment(-0.95, 0.0),
            end: Alignment(1.0, 0.0),
            colors: [Color(0xff667eea), Color(0xff64b6ff)],
            stops: [0.0, 1.0],
          ),
        ),
        child: const Center(
          child: Text(
            'Login',
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
    );
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
          fillColor: Color.fromARGB(255, 237, 238, 241),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
