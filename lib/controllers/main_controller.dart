import 'package:health_hack/models/user_model.dart';
import 'package:health_hack/models/workout_model.dart';
import 'package:health_hack/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysql_client/mysql_client.dart';

class MainController extends GetxController {
  MySQLConnection? connectionPool;
  UserModel? userData;
  int navBarIndex = 0;

  @override
  void onReady() async {
    super.onReady();
    connectionPool = await MySQLConnection.createConnection(
      host: Constants.host,
      port: 3306,
      userName: Constants.username,
      password: Constants.password,
      databaseName: Constants.databaseName,
      secure: false,
    );
    await connectionPool
        ?.connect()
        .then((value) => debugPrint('├─────────────────────────── connected'));
    await getUserData('abdulabbozov');
  }

  Future<void> getUserData(String ssn) async {
    IResultSet? result = await connectionPool?.execute(
        "SELECT * FROM user JOIN person USING(ssn) WHERE user.ssn='$ssn'");
    userData = UserModel(
      ssn: result?.rows.first.colAt(0) ?? '',
      height: double.tryParse(result?.rows.first.colAt(1) ?? '') ?? 0,
      weight: double.tryParse(result?.rows.first.colAt(2) ?? '') ?? 0,
      firstName: result?.rows.first.colAt(6),
      lastName: result?.rows.first.colAt(7),
      email: result?.rows.first.colAt(8) ?? "",
      dateOfBirth: DateTime.tryParse(result?.rows.first.colAt(3) ?? ''),
      workoutId: result?.rows.first.colAt(4),
      age: int.tryParse(result?.rows.first.colAt(5) ?? ''),
    );
    update();
  }

  void changeNavBar(int index) {
    navBarIndex = index;
    update();
  }

  List<Workouts> personalizedWorkouts() {
    return [
      Workouts(name: 'Workout for ABS', coverImage: 'abs'),
      Workouts(name: 'Workout for Arms', coverImage: 'arms'),
      Workouts(name: 'Workout for Legs', coverImage: 'legs'),
      Workouts(name: 'Workout for Back', coverImage: 'back'),
      Workouts(name: 'Yoga', coverImage: 'yoga'),
    ];
  }
}
