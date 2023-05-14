import 'package:flutter/material.dart';
import 'package:health_hack/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _height;
  String? _weight;
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  void editor(String a, String? h, TextEditingController c) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Wrap(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0))),
                child: TextFormField(
                  controller: c,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please enter your $a';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(label: Text('$a in cm')),
                  onFieldSubmitted: (v) {
                    Navigator.pop(context);
                  },
                  onChanged: (val) {
                    setState(() {
                      h = val;
                    });
                  },
                ),
              ),
            )
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text(
                'logout',
                style: TextStyle(
                  color: Constants.secondary5,
                ),
              ),
            ),
          ],
          title: const Text('Profile'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              height: 170,
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Constants.background,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage("assets/unknown_person.png"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              'Sardorbek Abdulabbozov',
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.w500),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                color: Constants.asset,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Constants.background,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("Height: "),
                      Text(heightController.text),
                      const Text('cm'),
                      IconButton(
                        onPressed: () {
                          editor('height', _height, heightController);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("Weight: "),
                      Text(weightController.text),
                      const Text('kg'),
                      IconButton(
                        onPressed: () {
                          editor('weight', _weight, weightController);
                        },
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
    );
  }
}
