import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_hack/controllers/main_controller.dart';
import 'package:health_hack/utils/constants.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (controller) => SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Constants.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 16, left: 16, bottom: 16),
                  child: Text(
                    'Explore Workouts',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.otherWorkouts.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) {
                      return InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: Get.height / 2.5,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Constants.primary,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Do you confirm register to this workout?',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Constants.assets,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          onPressed: Get.back,
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                OutlinedBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await controller
                                                .registerWorkout(controller
                                                    .otherWorkouts[i].id)
                                                .then(
                                                  (value) => Get.back(),
                                                );
                                          },
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                OutlinedBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: SizedBox(
                          width: Get.width - 32,
                          child: Stack(
                            children: [
                              Container(
                                width: Get.width - 32,
                                margin: EdgeInsets.only(left: i != 0 ? 12 : 0),
                                foregroundDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.black.withOpacity(0.6),
                                      Colors.black.withOpacity(0.4),
                                      Colors.black.withOpacity(0.2),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/ic_${controller.otherWorkouts[i].coverImage}.jpg',
                                    ),
                                  ),
                                ),
                              ),
                              if (controller.otherWorkouts[i].id ==
                                  controller.userWorkout?.id)
                                Positioned(
                                  left: Get.width - 120,
                                  top: 32,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Constants.primary,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        topLeft: Radius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Registered',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Constants.assets,
                                      ),
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 32, left: i != 0 ? 32 : 16),
                                child: Text(
                                  controller.otherWorkouts[i].name,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16, left: 16, bottom: 16),
                  child: Text(
                    'Report Injury',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Constants.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.injuryController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Constants.secondary4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async => await controller.addInjury(),
                            icon: const Icon(
                              Icons.send_rounded,
                              color: Constants.assets,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 200,
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: controller.injuries.isEmpty
                            ? const Center(
                                child: Text(
                                  'No injuries',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemBuilder: (_, i) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Row(
                                      children: [
                                        Text(
                                          controller.injuries[i].name,
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          controller.injuries[i].date,
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () async => await controller.removeInjury(controller.injuries[i].id),
                                          icon: const Icon(
                                            Icons.delete_rounded,
                                            color: Constants.secondary5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (_, i) {
                                  return const Divider();
                                },
                                itemCount: controller.injuries.length,
                              ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
