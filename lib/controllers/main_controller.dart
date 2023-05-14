// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:health_hack/models/user_model.dart';
import 'package:health_hack/models/workout_model.dart';
import 'package:health_hack/utils/base_functions.dart';
import 'package:health_hack/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysql_client/mysql_client.dart';

class MainController extends GetxController {
  MySQLConnection? connectionPool;
  UserModel? userData;
  WorkoutModel? userWorkout;
  List<WorkoutModel> otherWorkouts = [];
  int navBarIndex = 0;
  int dailyWaterAmount = 0;
  int dailySleepAmount = 0;

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
    await getUserData('abdulabbozov').then((v) async {
      await getUserWorkout('abdulabbozov');
      await getDailyWaterConsumption('abdulabbozov');
      await getSleepDuration('abdulabbozov');
    });
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

  Future<void> getUserWorkout(String ssn) async {
    IResultSet? result = await connectionPool?.execute(
        "SELECT workout.title, workout.id FROM workout JOIN user USING(id) WHERE user.ssn = '$ssn'");
    userWorkout = WorkoutModel(
      id: result?.rows.first.colAt(1) ?? '',
      name: result?.rows.first.colAt(0) ?? '',
      coverImage:
          BaseFunctions.getWorkoutCoverImage(result?.rows.first.colAt(1) ?? ''),
    );
    if ((result?.rows ?? []).isEmpty) {
      IResultSet? result =
          await connectionPool?.execute("SELECT * FROM workout");
      (result?.rows ?? []).forEach((row) {
        otherWorkouts.add(
          WorkoutModel(
            id: row.colAt(1) ?? '',
            name: row.colAt(0) ?? '',
            coverImage: BaseFunctions.getWorkoutCoverImage(row.colAt(1) ?? ''),
          ),
        );
      });
    }
    update();
  }

  Future<void> getSleepDuration(String ssn) async {
    var date = DateTime.now();
    IResultSet? result = await connectionPool?.execute(
        "SELECT * FROM sleep WHERE id='${date.day}.${date.month}.${date.year}' AND ssn = '$ssn'");
    if ((result?.rows ?? []).isEmpty) {
      dailySleepAmount = 0;
    } else {
      dailySleepAmount = int.tryParse(result?.rows.first.colAt(1) ?? '') ?? 0;
    }
    update();
  }

  Future<void> getDailyWaterConsumption(String ssn) async {
    var date = DateTime.now();
    IResultSet? result = await connectionPool?.execute(
        "SELECT * FROM water WHERE id='${date.day}.${date.month}.${date.year}' AND ssn = '$ssn'");
    if ((result?.rows ?? []).isEmpty) {
      dailyWaterAmount = 0;
    } else {
      dailyWaterAmount = int.tryParse(result?.rows.first.colAt(1) ?? '') ?? 0;
    }
    update();
  }

  Future<void> updateWaterAmount(int amount) async {
    var date = DateTime.now();
    await connectionPool?.execute(amount == 0
        ? "DELETE FROM water WHERE id='${date.day}.${date.month}.${date.year}' AND ssn = 'abdulabbozov'"
        : amount == 1 && dailyWaterAmount == 0
            ? "INSERT INTO water(id, amount, ssn) VALUES ('${date.day}.${date.month}.${date.year}','$amount','abdulabbozov')"
            : "UPDATE water SET amount='$amount' WHERE ssn = 'abdulabbozov'");
    dailyWaterAmount = amount;
    update();
  }

  void changeNavBar(int index) {
    navBarIndex = index;
    update();
  }

  List<WorkoutModel> personalizedWorkouts() {
    return [
      WorkoutModel(id: '1', name: 'Workout for ABS', coverImage: 'abs'),
      WorkoutModel(id: '2', name: 'Workout for Arms', coverImage: 'arms'),
      WorkoutModel(id: '3', name: 'Workout for Legs', coverImage: 'legs'),
      WorkoutModel(id: '4', name: 'Workout for Back', coverImage: 'back'),
      WorkoutModel(id: '5', name: 'Yoga', coverImage: 'yoga'),
    ];
  }
}
