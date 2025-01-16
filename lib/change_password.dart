import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:notatnik/hash.dart';
import 'package:notatnik/wavy_header.dart';
import 'package:notatnik/start_page.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final enteredPassword = TextEditingController();
  final newPassword = TextEditingController();
  final repeatedNewPassword = TextEditingController();
  bool obscureText = true;
  var activeScreen = 'changePassword';

  Future<bool> isOldPasswordCorrect(String password) {
    return PasswordHelper.verifyPassword(password);
  }

  void switchScreen() {
    setState(() {
      activeScreen = 'start_page';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (activeScreen == 'start_page') {
      return const StartPage();
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            WavyHeaderWithClippers(text: "Change Password", height: 200),
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
                                  color:
                                      const Color.fromRGBO(174, 108, 170, .2)),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color.fromRGBO(
                                                  174, 108, 170, .2)))),
                                  child: TextField(
                                      obscureText: true,
                                      controller: enteredPassword,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Current password",
                                          hintStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  94, 97, 97, 97))))),
                              Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color.fromRGBO(
                                                  174, 108, 170, .2)))),
                                  child: TextField(
                                      obscureText: true,
                                      controller: newPassword,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "New password",
                                          hintStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  94, 97, 97, 97))))),
                              Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                      obscureText: true,
                                      controller: repeatedNewPassword,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Repeat new password",
                                          hintStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  94, 97, 97, 97))))),
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
                                        bool correctOldPassword =
                                            await isOldPasswordCorrect(
                                                enteredPassword.text);
                                        if (correctOldPassword &&
                                            newPassword.text ==
                                                repeatedNewPassword.text) {
                                          PasswordHelper.savePassword(
                                              newPassword.text);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Success'),
                                                content: const Text(
                                                    'Password changed successfully'),
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
                                          switchScreen();
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Error'),
                                                content:
                                                    const Text('Try again'),
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
                                        "Zmien haslo",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(height: 30),
                    FadeInUp(
                        duration: const Duration(milliseconds: 2000),
                        child: IconButton(
                            icon: const Icon(Icons.home),
                            color: const Color.fromRGBO(143, 148, 251, 1),
                            onPressed: switchScreen))
                  ],
                ))
          ],
        )));
  }
}
