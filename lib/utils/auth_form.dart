import 'dart:io';
import 'package:flutter/material.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  final void Function(String email, String name, String password, File? image,
      bool isLogin, BuildContext ctx) passData;
  final bool _isLoading;

  const AuthForm(this.passData, this._isLoading, {super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _userName = '';
  String? _userEmail = '';
  String? _userPassword = '';
  late bool _isLogin;
  File? imagePicked;

  AuthMode authMode = AuthMode.signup;
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  final TextEditingController _pass = TextEditingController();

  late AnimationController _controller;

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

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (imagePicked == null && !(authMode == AuthMode.login)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pick an image first'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    if (isValid == true) {
      _formKey.currentState?.save();

      widget.passData(_userName!.trim(), _userEmail!.trim(),
          _userPassword!.trim(), imagePicked, _isLogin, context);
    }
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

  void imagePicker(File image) {
    imagePicked = image;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return
  }
}
