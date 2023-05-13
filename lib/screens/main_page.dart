import 'package:health_hack/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_hack/utils/base_functions.dart';
import 'package:health_hack/utils/constants.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (controller) => Scaffold(
        backgroundColor: Constants.background,
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Constants.background,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good ${BaseFunctions.getTimeBasedGreetings()} 🔥',
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 14,
                ),
              ),
              const Text(
                'Sardorbek Abdulabbozov',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        body:const Column(
          children: [],
        ),
      ),
    );
  }
}
