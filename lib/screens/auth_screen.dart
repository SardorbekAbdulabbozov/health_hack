// ignore_for_file: unused_field

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_hack/utils/constants.dart';
import 'package:intl/intl.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _height;
  DateTime? _birthday;
  String? _weight;
  String? _userId;
  String? _userName = '';
  String? _userEmail = '';
  String? _userPassword = '';
  late bool _isLogin;
  bool light = false;
  File? imagePicked;
  DateTime? selectedDate;

  AuthMode authMode = AuthMode.signup;
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#&*~]).{8,}$');

  final TextEditingController _pass = TextEditingController();

  late AnimationController _controller;
  Widget password(){
    return TextFormField(
      controller: _pass,
      validator: (val) {
        if (val!.isEmpty) {
          return 'Please enter password';
        }
        if (val.length < 6) {
          return 'Password should be at least 8 characters long';
        }
        if (!regex.hasMatch(val)) {
          return 'Enter a valid password: The password should contain digits, symbols, capital letter, and lower case letter';
        }
        return null;
      },
      obscuringCharacter: '*',
      obscureText: true,
      decoration: const InputDecoration(
          label: Text('Password')),
      onSaved: (val) {
        _userPassword = val;
      },
    );
  }
  Widget emailAddress(){
    return TextFormField(
      validator: (val) {
        if (val!.isEmpty) {
          return 'Please enter email address';
        }
        if (!(val.endsWith('.com')) ||
            !(val.contains('@'))) {
          return 'Enter a valid email address';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          label: Text('Email Address')),
      onSaved: (val) {
        _userEmail = val;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _isLogin = false;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeAuthMode() {
    setState(() {
      authMode == AuthMode.signup
          ? {authMode = AuthMode.login, _isLogin = true, _controller.forward()}
          : {
              authMode = AuthMode.signup,
              _isLogin = false,
              _controller.reverse()
            };
    });
  }

  void _selectDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  void imagePicker(File image) {
    imagePicked = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (isValid == true) {
      _formKey.currentState?.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/ic_background.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Card(
            color: const Color.fromRGBO(247, 246, 251, 0.8),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
                height: authMode == AuthMode.signup ? 480 : 240,
                // height: _heightAnimation.value.height,
                constraints: BoxConstraints(
                    minHeight: authMode == AuthMode.signup ? 480 : 240),
                width: deviceSize.width * 0.75,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        emailAddress(),
                        authMode == AuthMode.signup
                            ? Column(
                                children: [
                                  TextFormField(
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'Please enter username';
                                      }
                                      if (val.length < 6) {
                                        return 'At least 6 characters';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.name,
                                    decoration: const InputDecoration(
                                        label: Text('Full Name')),
                                    onSaved: (val) {
                                      _userName = val;
                                    },
                                  ),
                                  password(),
                                  TextFormField(
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'Please enter password';
                                      }

                                      if (authMode == AuthMode.signup &&
                                          val != _pass.text) {
                                        return 'Passwords did not match';
                                      }
                                      if (val.length < 6) {
                                        return 'Password should be at least 8 characters long';
                                      }
                                      if (!regex.hasMatch(val)) {
                                        return 'Enter a valid password: The password should contain digits, symbols, capital letter, and lower case letter';
                                      }

                                      return null;
                                    },
                                    obscuringCharacter: '*',
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      label: Text('Confirm Password'),
                                    ),
                                    onSaved: (val) {
                                      _userPassword = val;
                                    },
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          selectedDate == null
                                              ? 'No Date chosen'
                                              : 'Date of Birth: ${DateFormat.yMd().format(selectedDate!)}',
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: _selectDate,
                                        child: const Text(
                                          'Date of Birth',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('User'),
                                        Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: Switch(
                                            value: light,
                                            onChanged: (bool b) {
                                              setState(() {
                                                light = b;
                                              });
                                            },
                                          ),
                                        ),
                                        const Text('Trainer'),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  password(),
                                ],
                              ),
                        const SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(
                          onPressed: _trySubmit,
                          child: Text(authMode == AuthMode.signup
                              ? 'Sign Up'
                              : 'Log in'),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextButton(
                          onPressed: changeAuthMode,
                          child: Text(
                              '${authMode == AuthMode.signup ? 'LOG IN' : 'SIGN UP'} INSTEAD'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
