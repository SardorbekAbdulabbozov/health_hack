// ignore_for_file: deprecated_member_use

import 'package:flutter_svg/flutter_svg.dart';
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
                  fontSize: 12,
                ),
              ),
              const Text(
                'Sardorbek Abdulabbozov',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      'assets/ic_search.svg',
                    ),
                  ),
                  hintText: 'Coming soon...',
                  hintStyle: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(32)),
            child: BottomNavigationBar(
              backgroundColor: Constants.asset,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Constants.primary,
              currentIndex: controller.navBarIndex,
              showUnselectedLabels: false,
              onTap: controller.changeNavBar,
              items: [
                navBarItem(label: 'Home', icon: 'assets/ic_home.svg'),
                navBarItem(label: 'Activities', icon: 'assets/ic_rocket.svg'),
                navBarItem(label: 'Records', icon: 'assets/ic_statistic.svg'),
                navBarItem(label: 'Profile', icon: 'assets/ic_profile.svg'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

BottomNavigationBarItem navBarItem(
    {required String label, required String icon}) {
  return BottomNavigationBarItem(
    icon: SvgPicture.asset(
      icon,
      color: Colors.white,
    ),
    label: label,
    activeIcon: SvgPicture.asset(
      icon,
      color: Constants.primary,
    ),
  );
}
