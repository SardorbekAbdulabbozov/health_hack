import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/auth_form.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isLoading;
  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              height: authMode == AuthMode.signup ? 420 : 240,
              // height: _heightAnimation.value.height,
              constraints: BoxConstraints(
                  minHeight: authMode == AuthMode.signup ? 420 : 240),
              width: deviceSize.width * 0.75,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
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
                        decoration:
                        const InputDecoration(label: Text('Email address')),
                        onSaved: (val) {
                          _userEmail = val;
                        },
                      ),
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
                                label: Text('Username')),
                            onSaved: (val) {
                              _userName = val;
                            },
                          ),
                          TextFormField(
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
                          ),
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
                            decoration: InputDecoration(
                              label: Text(authMode == AuthMode.signup
                                  ? 'Confirm Password'
                                  : 'Password'),
                            ),
                            onSaved: (val) {
                              _userPassword = val;
                            },
                          ),
                        ],
                      )
                          : TextFormField(
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
                        decoration:
                        const InputDecoration(label: Text('Password')),
                        onSaved: (val) {
                          _userPassword = val;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      widget._isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
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
      );,
    );
  }
}
