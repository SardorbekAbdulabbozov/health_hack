// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:health_hack/utils/constants.dart';

class MyWaterConsumption extends StatelessWidget {
  const MyWaterConsumption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: Get.width - 32,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              color: Constants.primary,
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            child: SvgPicture.asset(
              'assets/ic_water.svg',
              color: Constants.asset,
              width: 48,
              height: 48,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Water Consumption',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: Get.width / 1.8,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(const CircleBorder()),
                        ),
                        child: const Icon(Icons.remove_rounded),
                      ),
                      const Spacer(),
                      const Text(
                        '2 glass(es)',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(const CircleBorder()),
                        ),
                        child: const Icon(Icons.add_rounded),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
