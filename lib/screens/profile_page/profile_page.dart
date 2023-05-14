// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:health_hack/controllers/main_controller.dart';
import 'package:health_hack/utils/constants.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _height;
  String? _weight;
  String? _email;
  String? _birthdate;
  bool isVisible = false;
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  DateTime? newBirthdate;
  final mainController = Get.find<MainController>();

  @override
  void initState() {
    super.initState();
    nameController.text =
        '${mainController.userData?.firstName} ${mainController.userData?.lastName}';
    heightController.text = '${mainController.userData?.height ?? 0}';
    weightController.text = '${mainController.userData?.weight ?? 0}';
    _email = mainController.userData?.email ?? '';
    _birthdate = mainController.userData?.dateOfBirth != null
        ? DateFormat.yMd().format(mainController.userData!.dateOfBirth!)
        : null;
    setState(() {});
  }

  void editor(String a, String? h, TextEditingController c) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (BuildContext bc) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
          ),
          child: SizedBox(
            child: TextFormField(
              controller: c,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please enter your $a';
                }
                return null;
              },
              keyboardType:
                  a == 'full name' ? TextInputType.text : TextInputType.number,
              decoration: InputDecoration(
                label: a == 'full name'
                    ? const Text(
                        'Full Name',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                        ),
                      )
                    : Text(
                        '${a.capitalizeFirst} in cm',
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                        ),
                      ),
              ),
              onFieldSubmitted: (v) {
                Navigator.pop(context);
              },
              onChanged: (val) {
                setState(() {
                  h = val;
                  isVisible = true;
                });
              },
            ),
          ),
        );
      },
    );
  }

  void _selectDate() async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        newBirthdate = pickedDate;
        isVisible = true;
        _birthdate = DateFormat.yMd().format(pickedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Constants.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          backgroundColor: Constants.background,
          actions: [
            TextButton(
              onPressed: () async {
                await mainController.logout();
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Constants.secondary5,
                ),
              ),
            ),
          ],
          title: const Text(
            'Profile',
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              height: 360,
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 50),
                      Container(
                        height: 310,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Constants.primary,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Constants.background,
                          child: SvgPicture.asset(
                            'assets/ic_user_circle.svg',
                            width: 200,
                            height: 200,
                            color: Constants.assets,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          nameController.text == ''
                              ? 'Sardorbek Abdulabbozov'
                              : nameController.text,
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Email:",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 76),
                                  Text(
                                    _email ?? "Not set",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  Visibility(
                                    visible: false,
                                    child: IconButton(
                                      onPressed: () {
                                        editor(
                                          'height',
                                          _height,
                                          heightController,
                                        );
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Height:",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 68),
                                  Text(
                                    heightController.text.isEmpty
                                        ? 'Not set'
                                        : heightController.text,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  if (heightController.text.isNotEmpty)
                                    const Text(
                                      'cm',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      editor(
                                        'height',
                                        _height,
                                        heightController,
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Weight:",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 64),
                                  Text(
                                    weightController.text.isEmpty
                                        ? 'Not set'
                                        : weightController.text,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  if (weightController.text.isNotEmpty)
                                    const Text(
                                      'kg',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      editor(
                                        'weight',
                                        _weight,
                                        weightController,
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Date of Birth:",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 26),
                                  Text(
                                    _birthdate ?? 'Not set',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: _selectDate,
                                    icon: const Icon(Icons.edit),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Visibility(
              visible: isVisible,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Constants.assets),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                onPressed: () async {
                  await mainController
                      .updateProfile(
                        height: double.tryParse(heightController.text) ?? 0,
                        weight: double.tryParse(weightController.text) ?? 0,
                        birthdate: newBirthdate ?? DateTime.now(),
                      )
                      .then(
                        (value) => setState(() {
                          isVisible = false;
                        }),
                      );
                },
                child: const Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
