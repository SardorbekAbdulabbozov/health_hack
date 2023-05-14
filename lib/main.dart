import 'package:get_storage/get_storage.dart';
import 'package:health_hack/bindings/main_binding.dart';
import 'package:health_hack/screens/auth_page/auth_page.dart';
import 'package:health_hack/screens/main_page/main_page.dart';
import 'package:health_hack/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
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
        colorScheme: ColorScheme.fromSeed(seedColor: Constants.assets,primary: Constants.assets),
        useMaterial3: true,
      ),
      routes: {
        Constants.mainR: (c) => const MainPage(),
        Constants.authR: (c) => const AuthPage(),
      },
    );
  }
}
