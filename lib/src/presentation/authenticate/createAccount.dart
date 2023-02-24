import 'package:cpscom/src/presentation/authenticate/homeScreen.dart';
import 'package:cpscom/src/presentation/authenticate/loginScree.dart';
import 'package:cpscom/src/presentation/authenticate/methods.dart';
import 'package:cpscom/src/utils/messgaetoast.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.height * 0.50,
                        alignment: Alignment.center,
                        child: field(size, "Name", Icons.account_box, _name),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.height * 0.50,
                      alignment: Alignment.center,
                      child: field(size, "Email", Icons.email, _email),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.height * 0.50,
                        alignment: Alignment.center,
                        child: field(size, "Password", Icons.lock, _password),
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
                        : customButton(size),
                    SizedBox(
                      height: size.height / 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Already have an account?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => LoginScreen())),
                          child: const Text(
                            'SIGN IN',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff64b6ff),
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

    // return Scaffold(
    //   body: Container(
    //     decoration: const BoxDecoration(
    //       image: DecorationImage(
    //         image: AssetImage("assets/images/group_bg.png"),
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //     child: isLoading
    //         ? Center(
    //             child: SizedBox(
    //               height: size.height / 20,
    //               width: size.height / 20,
    //               child: const CircularProgressIndicator(),
    //             ),
    //           )
    //         : SingleChildScrollView(
    //             child: Padding(
    //               padding: const EdgeInsets.all(16.0),
    //               child: Column(
    //                 children: [
    //                   SizedBox(
    //                     height: size.height / 10,
    //                   ),
    //                   Padding(
    //                     padding: const EdgeInsets.only(top: 50.0),
    //                     child: SizedBox(
    //                       // height: deviceSizeConfig.blockSizeVertical * 40,
    //                       width: double.infinity,
    //                       child: Image.asset(
    //                         'assets/images/header_icon.png',
    //                         height: 50,
    //                       ),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     width: size.width / 1.1,
    //                     child: const Text(
    //                       "CPSCOM",
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                         fontSize: 20,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: size.height / 10,
    //                   ),
    //                   Padding(
    //                     padding: const EdgeInsets.symmetric(vertical: 18.0),
    //                     child: Container(
    //                       height: MediaQuery.of(context).size.height * 0.06,
    //                       width: MediaQuery.of(context).size.height * 0.60,
    //                       alignment: Alignment.center,
    //                       child: field(size, "Name", Icons.account_box, _name),
    //                     ),
    //                   ),
    //                   Container(
    //                     height: MediaQuery.of(context).size.height * 0.06,
    //                     width: MediaQuery.of(context).size.height * 0.60,
    //                     alignment: Alignment.center,
    //                     child: field(size, "email", Icons.email, _email),
    //                   ),
    //                   Padding(
    //                     padding: const EdgeInsets.symmetric(vertical: 18.0),
    //                     child: Container(
    //                       height: MediaQuery.of(context).size.height * 0.06,
    //                       width: MediaQuery.of(context).size.height * 0.60,
    //                       alignment: Alignment.center,
    //                       child: field(size, "password", Icons.lock, _password),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: size.height / 40,
    //                   ),
    //                   customButton(size),
    //                   const SizedBox(
    //                     height: 15.0,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: <Widget>[
    //                       const Text(
    //                         'Already have an account?',
    //                         style: TextStyle(
    //                           fontSize: 12,
    //                           fontWeight: FontWeight.w600,
    //                         ),
    //                       ),
    //                       const SizedBox(
    //                         width: 5.0,
    //                       ),
    //                       GestureDetector(
    //                         onTap: () => Navigator.of(context).push(
    //                             MaterialPageRoute(
    //                                 builder: (_) => LoginScreen())),
    //                         child: const Text(
    //                           'SIGN IN',
    //                           style: TextStyle(
    //                             fontSize: 14,
    //                             fontWeight: FontWeight.w600,
    //                             color: Color(0xff64b6ff),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: size.height / 1,
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //   ),
    // );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_name.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          createAccount(_name.text, _email.text, _password.text).then((user) {
            if (user != null) {
              setState(() {
                isLoading = false;
              });
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
              print("Account Created Sucessfull");
              showToastMessage('Account Created Sucessfull');
            } else {
              print("Login Failed");
              showToastMessage(
                  'The email address is already in use by another account.');
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          //print("Please enter Fields");
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.height * 0.30,
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
            'SIGN UP',
            style: TextStyle(
              fontSize: 18,
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
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        controller: cont,
        //cursorColor: Colors.,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          filled: true,
          fillColor: Color.fromARGB(255, 237, 238, 241),
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
