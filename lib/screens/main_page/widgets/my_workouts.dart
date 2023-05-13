import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_hack/controllers/main_controller.dart';
import 'package:health_hack/utils/constants.dart';

class MyWorkouts extends GetView<MainController> {
  const MyWorkouts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Workout',
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: 1, //controller.personalizedWorkouts().length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                return Stack(
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
                            'assets/ic_${controller.personalizedWorkouts()[i].coverImage}.jpg',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: i != 0 ? 32 : 16),
                      child: Text(
                        controller.personalizedWorkouts()[i].name,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      left: Get.width - 176,
                      bottom: 16,
                      child: const Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Constants.primary,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Constants.primary,
                              size: 36,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
