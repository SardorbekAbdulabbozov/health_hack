// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_hack/utils/base_functions.dart';
import 'package:health_hack/utils/constants.dart';

class MainAppBar extends StatelessWidget {
  final String? username;

  const MainAppBar({Key? key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          Text(
            username ?? 'Sardorbek Abdulabbozov',
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

BottomNavigationBarItem navBarItem(
    {required String label, required String icon}) {
  return BottomNavigationBarItem(
    backgroundColor: Colors.transparent,
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

