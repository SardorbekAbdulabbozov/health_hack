import 'package:health_hack/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (controller) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.data,
              ),
              ElevatedButton(
                onPressed: () async {
                  await controller.getData('user', false);
                },
                child: const Text('Send SQL Query '),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
