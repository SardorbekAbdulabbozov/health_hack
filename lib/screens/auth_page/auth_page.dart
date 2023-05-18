// ignore_for_file: unused_field

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_hack/controllers/main_controller.dart';
import 'package:health_hack/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:health_hack/models/user_model.dart';

enum AuthMode { signup, login }

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _height;
  DateTime? _birthday;
  String? _weight;
  String? _userId;
  String? _userFName = '';
  String? _userLName = '';
  String? _userEmail = '';
  String? _userPassword = '';
  late bool _isLogin;
  bool isTrainer = false;
  DateTime? selectedDate;

  AuthMode authMode = AuthMode.signup;
  /*RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#&*~]).{8,}$');*/

  final TextEditingController _password = TextEditingController();

  late AnimationController _controller;

  Widget password() {
    return TextFormField(
      controller: _password,
      /*validator: (val) {
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
      },*/
      obscuringCharacter: '*',
      obscureText: true,
      cursorColor: Constants.assets,
      decoration: const InputDecoration(
        label: Text('Password'),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Constants.assets,
            width: 2,
          ),
        ),
      ),
      onSaved: (val) {
        _userPassword = val;
      },
    );
  }

  Widget emailAddress() {
    return TextFormField(
      validator: (val) {
        if (val!.isEmpty) {
          return 'Please enter email address';
        }
        if (!(val.endsWith('.com')) || !(val.contains('@'))) {
          return 'Enter a valid email address';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      cursorColor: Constants.assets,
      decoration: const InputDecoration(
        label: Text('Email Address'),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Constants.assets,
            width: 2,
          ),
        ),
      ),
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

  void _selectDate() async {
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
        _birthday = pickedDate;
      });
    });
  }

  void _trySubmit(bool isSignUp) {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (isValid == true) {
      _formKey.currentState?.save();
      if (isSignUp) {
        Get.find<MainController>().signUp(
          UserModel(
            ssn:
                '${(_userEmail ?? 'abcd').substring(0, 3)}${Random().nextInt(99)}_id',
            firstName: _userFName,
            lastName: _userLName,
            email: _userEmail ?? '',
            dateOfBirth: _birthday,
            age: DateTime.now().difference(_birthday ?? DateTime.now()).inDays~/365,
          ),
          _userPassword ?? '',
        );
      } else {
        Get.find<MainController>().login(_userEmail ?? '', _userPassword ?? '');
      }
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
                        if (authMode == AuthMode.signup)
                          Column(
                            children: [
                              TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please enter first name';
                                  }
                                  if (val.length < 6) {
                                    return 'At least 6 characters';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.name,
                                cursorColor: Constants.assets,
                                decoration: const InputDecoration(
                                  label: Text('First Name'),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Constants.assets,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onSaved: (val) {
                                  _userFName = val;
                                },
                              ),
                              TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please enter last name';
                                  }
                                  if (val.length < 6) {
                                    return 'At least 6 characters';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.name,
                                cursorColor: Constants.assets,
                                decoration: const InputDecoration(
                                  label: Text('Last Name'),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Constants.assets,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onSaved: (val) {
                                  _userLName = val;
                                },
                              ),
                              password(),
                              TextFormField(
                                /*validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please enter password';
                                  }

                                  if (authMode == AuthMode.signup &&
                                      val != _password.text) {
                                    return 'Passwords did not match';
                                  }
                                  if (val.length < 6) {
                                    return 'Password should be at least 8 characters long';
                                  }
                                  if (!regex.hasMatch(val)) {
                                    return 'Enter a valid password: The password should contain digits, symbols, capital letter, and lower case letter';
                                  }

                                  return null;
                                },*/
                                obscuringCharacter: '*',
                                obscureText: true,
                                cursorColor: Constants.assets,
                                decoration: const InputDecoration(
                                  label: Text('Confirm Password'),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Constants.assets,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onSaved: (val) {
                                  _userPassword = val;
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: _selectDate,
                                    child: const Text(
                                      'Date of Birth',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w900,
                                        color: Constants.assets,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      selectedDate == null
                                          ? 'No Date chosen'
                                          : 'Date of Birth: ${DateFormat.yMd().format(selectedDate!)}',
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        color: Constants.assets,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: false,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'User',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.w600,
                                          color: Constants.assets,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Switch(
                                          value: isTrainer,
                                          activeColor: Constants.primary,
                                          activeTrackColor: Constants.assets,
                                          onChanged: (bool b) {
                                            setState(() {
                                              isTrainer = b;
                                            });
                                          },
                                        ),
                                      ),
                                      const Text(
                                        'Trainer',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.w600,
                                          color: Constants.assets,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Column(children: [password()]),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () =>
                              _trySubmit(authMode == AuthMode.signup),
                          child: Text(
                            authMode == AuthMode.signup ? 'Sign Up' : 'Log in',
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              color: Constants.assets,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: changeAuthMode,
                          child: Text(
                            '${authMode == AuthMode.signup ? 'LOG IN' : 'SIGN UP'} INSTEAD',
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w700,
                              color: Constants.assets,
                            ),
                          ),
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
