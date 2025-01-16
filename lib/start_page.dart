import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:notatnik/change_password.dart';
import 'package:notatnik/notebook_page.dart';
import 'package:notatnik/hash.dart';
import 'package:notatnik/wavy_header.dart';
import 'package:local_auth/local_auth.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});
  @override
  State<StartPage> createState() => _StartPageState();
}

@override
class _StartPageState extends State<StartPage> {
  final enteredPassword = TextEditingController();
  bool obscureText = true;
  var activeScreen = 'start';
  final LocalAuthentication auth = LocalAuthentication();
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });

    if (authenticated) {
      switchScreenToNotebook();
    }
  }

  void switchScreenToNotebook() {
    setState(() {
      activeScreen = 'notebook';
    });
  }

  void switchScreenToChangePassword() {
    setState(() {
      activeScreen = 'change_password';
    });
  }

  @override
  void dispose() {
    enteredPassword.dispose();
    super.dispose();
  }

  Future<bool> isPasswordCorrect(String password) {
    return PasswordHelper.verifyPassword(password);
  }

  @override
  Widget build(BuildContext context) {
    if (activeScreen == 'notebook') {
      return const NotebookPage();
    }
    if (activeScreen == 'change_password') {
      return const ChangePassword();
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            WavyHeaderWithClippers(text: "Enter Password", height: 200),
            const SizedBox(height: 40),
            Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                        duration: const Duration(milliseconds: 1800),
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color.fromRGBO(
                                        174, 108, 170, .2)),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(children: <Widget>[
                              Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                      controller: enteredPassword,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  94, 97, 97, 97))))),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1900),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(colors: [
                                          Color.fromRGBO(174, 108, 170, 1),
                                          Color.fromRGBO(143, 148, 251, .6),
                                        ])),
                                    child: Center(
                                        child: TextButton(
                                      onPressed: () async {
                                        bool correct = await isPasswordCorrect(
                                            enteredPassword.text);
                                        if (correct) {
                                          switchScreenToNotebook();
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Error'),
                                                content: const Text(
                                                    'Password Incorrect'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: const Text(
                                        "Login with password",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                  )),
                              const SizedBox(
                                height: 30,
                              ),
                              FadeInUp(
                                  duration: const Duration(milliseconds: 2000),
                                  child: GestureDetector(
                                    onTap: () {
                                      switchScreenToChangePassword();
                                    },
                                    child: const Text(
                                      "Want to change password?",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(143, 148, 251, 1)),
                                    ),
                                  ))
                            ]))),
                    const SizedBox(height: 60),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1800),
                      child: IconButton(
                        onPressed: () async {
                          print('Authenticating with biometrics');
                          await _authenticateWithBiometrics();
                        },
                        icon: const Icon(
                          Icons.fingerprint, // Ikona odcisku palca
                          color: Color.fromRGBO(
                              174, 108, 170, 1), // Fioletowy kolor
                          size: 30, // Rozmiar ikony
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        )));
  }
}
