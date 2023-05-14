import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_hack/controllers/main_controller.dart';
import 'package:health_hack/models/workout_model.dart';
import 'package:health_hack/utils/constants.dart';

class MyWorkouts extends GetView<MainController> {
  const MyWorkouts({
    Key? key,
    required this.id,
    required this.name,
    required this.coverImage,
    required this.otherWorkouts,
  }) : super(key: key);
  final String id;
  final String name;
  final String coverImage;
  final List<WorkoutModel> otherWorkouts;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name.isNotEmpty ? 'My Workout' : 'Popular Workouts',
            style: const TextStyle(
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
              itemCount: name.isNotEmpty ? 1 : otherWorkouts.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                return InkWell(
                  onTap: () {
                    controller
                        .getExercises(
                          name.isNotEmpty ? id : otherWorkouts[i].id,
                        )
                        .then(
                          (value) => showModalBottomSheet(
                            isScrollControlled: false,
                            context: context,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25),
                              ),
                            ),
                            builder: (_) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: 16,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: SizedBox(
                                  width: Get.width,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Exercises related to ${name.isNotEmpty ? name : otherWorkouts[i].name}',
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Constants.assets,
                                        ),
                                      ),
                                      const Divider(),
                                      Expanded(
                                        child: ListView.separated(
                                          shrinkWrap: false,
                                          itemBuilder: (_, i) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 4,
                                                horizontal: 16,
                                              ),
                                              child: Text(
                                                controller.exercises[i],
                                                style: const TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Constants.assets,
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount:
                                              controller.exercises.length,
                                          separatorBuilder: (_, i) =>
                                              const Divider(),
                                        ),
                                      ),
                                      const Divider(),
                                      Text(
                                        'Equipments related to ${name.isNotEmpty ? name : otherWorkouts[i].name}',
                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Constants.assets,
                                        ),
                                      ),
                                      const Divider(),
                                      Expanded(
                                        child: ListView.separated(
                                          shrinkWrap: false,
                                          itemBuilder: (_, i) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                // vertical: 4,
                                                horizontal: 16,
                                              ),
                                              child: ExpandablePanel(
                                                collapsed:
                                                    const SizedBox.shrink(),
                                                expanded: Text(
                                                  controller.equipments[i]
                                                      .description,
                                                  style: const TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 16,
                                                    color: Constants.assets,
                                                  ),
                                                ),
                                                header: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12),
                                                  child: Text(
                                                    controller
                                                        .equipments[i].name,
                                                    style: const TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Constants.assets,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount:
                                              controller.equipments.length,
                                          separatorBuilder: (_, i) =>
                                              const Divider(),
                                        ),
                                      ),
                                      const Divider(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                  },
                  child: SizedBox(
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
                                'assets/ic_${name.isNotEmpty ? coverImage : otherWorkouts[i].coverImage}.jpg',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 16, left: i != 0 ? 32 : 16),
                          child: Text(
                            name.isNotEmpty ? name : otherWorkouts[i].name,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (name.isNotEmpty)
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
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
