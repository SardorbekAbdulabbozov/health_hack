import 'package:health_hack/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_hack/screens/explore_page/explore_page.dart';
import 'package:health_hack/screens/info_page/info_page.dart';
import 'package:health_hack/screens/main_page/widgets/custom_search_bar.dart';
import 'package:health_hack/screens/main_page/widgets/main_app_bar.dart';
import 'package:health_hack/screens/main_page/widgets/my_water_consumption.dart';
import 'package:health_hack/screens/main_page/widgets/my_workouts.dart';
import 'package:health_hack/screens/profile_page/profile_page.dart';
import 'package:health_hack/utils/constants.dart';

import 'widgets/my_sleep_duration.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (controller) {
        List<Widget> pages = [
          Column(
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
          const ExplorePage(),
          const InfoPage(),
          const ProfilePage(),
        ];
        return Scaffold(
          backgroundColor: Constants.background,
          appBar: controller.navBarIndex == 0
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(90),
                  child: MainAppBar(
                    username: ((controller.userData?.firstName ?? '')
                                .isNotEmpty ||
                            (controller.userData?.lastName ?? '').isNotEmpty)
                        ? '${controller.userData?.firstName ?? ""} ${controller.userData?.lastName ?? ''}'
                        : 'Dear user',
                  ),
                )
              : null,
          body: pages[controller.navBarIndex],
          bottomNavigationBar: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(canvasColor: Colors.transparent),
                child: BottomNavigationBar(
                  elevation: 0,
                  // backgroundColor: Color(0x00ffffff),
                  backgroundColor: Constants.assets,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Constants.primary,
                  currentIndex: controller.navBarIndex,
                  showUnselectedLabels: false,
                  onTap: (i) {
                    controller.changeNavBar(i);
                  },
                  items: [
                    navBarItem(label: 'Home', icon: 'assets/ic_home.svg'),
                    navBarItem(label: 'Explore', icon: 'assets/ic_rocket.svg'),
                    navBarItem(label: 'Info', icon: 'assets/ic_statistic.svg'),
                    navBarItem(label: 'Profile', icon: 'assets/ic_profile.svg'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
