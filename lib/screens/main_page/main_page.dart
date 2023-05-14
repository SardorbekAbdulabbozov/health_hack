import 'package:health_hack/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_hack/screens/main_page/widgets/custom_search_bar.dart';
import 'package:health_hack/screens/main_page/widgets/main_app_bar.dart';
import 'package:health_hack/screens/main_page/widgets/my_water_consumption.dart';
import 'package:health_hack/screens/main_page/widgets/my_workouts.dart';
import 'package:health_hack/utils/constants.dart';

import 'widgets/my_sleep_duration.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (controller) => Scaffold(
        backgroundColor: Constants.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: MainAppBar(
            username: ((controller.userData?.firstName ?? '').isNotEmpty ||
                    (controller.userData?.lastName ?? '').isNotEmpty)
                ? '${controller.userData?.firstName ?? ""} ${controller.userData?.lastName ?? ''}'
                : 'Dear user',
          ),
        ),
        body: Column(
          children: [
            const CustomSearchBar(),
            MyWorkouts(
              id: controller.userWorkout?.id ?? '',
              name: controller.userWorkout?.name ?? '',
              coverImage: controller.userWorkout?.coverImage ?? '',
              otherWorkouts: controller.otherWorkouts,
            ),
            MyWaterConsumption(
              amount: controller.dailyWaterAmount,
              onChanged: (i) async {
                await controller.updateWaterAmount(i);
              },
            ),
            const SizedBox(height: 16),
            MySleepDuration(amount: controller.dailySleepAmount),
          ],
        ),
        bottomNavigationBar: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
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
                navBarItem(label: 'Explore', icon: 'assets/ic_rocket.svg'),
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
