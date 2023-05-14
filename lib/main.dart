import 'package:health_hack/bindings/main_binding.dart';
import 'package:health_hack/screens/auth_screen.dart';
import 'package:health_hack/screens/main_page/main_page.dart';
import 'package:health_hack/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main()  {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DB Project Test',
      initialRoute: Constants.authR,
      initialBinding: MainBinding(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        Constants.mainR: (c) => const MainPage(),
        Constants.authR: (c)=> const AuthScreen(),
        // Constants.authR:(c)=>const AuthPage(),
        // Constants.homeR:(c)=>const HomePage(),
      },
    );
  }
}