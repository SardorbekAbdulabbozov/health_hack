// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:math';

import 'package:health_hack/models/equipment_model.dart';
import 'package:health_hack/models/injury_model.dart';
import 'package:health_hack/models/user_model.dart';
import 'package:health_hack/models/workout_model.dart';
import 'package:health_hack/storage/local_source.dart';
import 'package:health_hack/utils/base_functions.dart';
import 'package:health_hack/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mysql_client/mysql_client.dart';

class MainController extends GetxController {
  MySQLConnection? connectionPool;
  UserModel? userData;
  WorkoutModel? userWorkout;
  List<WorkoutModel> otherWorkouts = [];
  List<String> exercises = [];
  List<EquipmentModel> equipments = [];
  List<InjuryModel> injuries = [];
  int navBarIndex = 0;
  int dailyWaterAmount = 0;
  int dailySleepAmount = 0;
  LocalSource localSource = LocalSource();
  TextEditingController injuryController = TextEditingController();

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
    if (localSource.hasProfile()) {
      Get.offAllNamed(Constants.mainR);
      var ssn = localSource.getSSN();
      await getUserData(ssn).then((v) async {
        await getUserWorkout(ssn);
        await getDailyWaterConsumption(ssn);
        await getSleepDuration(ssn);
      });
    }
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

  Future<void> getOtherWorkouts() async {
    otherWorkouts = [];
    IResultSet? result = await connectionPool?.execute("SELECT * FROM workout");
    (result?.rows ?? []).forEach((row) {
      otherWorkouts.add(
        WorkoutModel(
          id: row.colAt(0) ?? '',
          name: row.colAt(1) ?? '',
          coverImage: BaseFunctions.getWorkoutCoverImage(row.colAt(0) ?? ''),
        ),
      );
    });
    update();
  }

  Future<void> getInjuries() async {
    injuries = [];
    IResultSet? result = await connectionPool?.execute(
        "SELECT  id, name, date FROM injury WHERE ssn ='${localSource.getSSN()}'");
    (result?.rows ?? []).forEach((row) {
      injuries.add(
        InjuryModel(
          id: row.colAt(0) ?? '',
          name: row.colAt(1) ?? '',
          date: DateFormat.yMd().format(
            DateTime.tryParse(row.colAt(2) ?? '') ?? DateTime.now(),
          ),
        ),
      );
    });
    update();
  }

  Future<void> addInjury() async {
    await connectionPool
        ?.execute(
            "INSERT INTO injury (ssn, id, name, date) VALUES ('${localSource.getSSN()}','${localSource.getSSN()}${Random().nextInt(100)}','${injuryController.text}','${DateTime.now()}')")
        .then((value) async {
      await getInjuries();
    });
  }

  Future<void> removeInjury(String id) async {
    await connectionPool
        ?.execute(
            "DELETE FROM injury WHERE id ='$id' AND ssn ='${localSource.getSSN()}'")
        .then((value) async {
      await getInjuries();
    });
  }

  Future<void> getUserWorkout(String ssn) async {
    IResultSet? result = await connectionPool?.execute(
        "SELECT workout.title, workout.id FROM workout JOIN user USING(id) WHERE user.ssn = '$ssn'");

    if ((result?.rows ?? []).isEmpty) {
      IResultSet? result =
          await connectionPool?.execute("SELECT * FROM workout");
      (result?.rows ?? []).forEach((row) {
        otherWorkouts.add(
          WorkoutModel(
            id: row.colAt(0) ?? '',
            name: row.colAt(1) ?? '',
            coverImage: BaseFunctions.getWorkoutCoverImage(row.colAt(0) ?? ''),
          ),
        );
      });
    } else {
      userWorkout = WorkoutModel(
        id: result?.rows.first.colAt(1) ?? '',
        name: result?.rows.first.colAt(0) ?? '',
        coverImage: BaseFunctions.getWorkoutCoverImage(
            result?.rows.first.colAt(1) ?? ''),
      );
    }
    update();
  }

  Future<void> getSleepDuration(String ssn) async {
    var date = DateTime.now();
    IResultSet? result = await connectionPool?.execute(
        "SELECT * FROM sleep WHERE id='${date.day}.${date.month}$ssn' AND ssn = '$ssn'");
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
        "SELECT * FROM water WHERE id='${date.day}.${date.month}$ssn' AND ssn = '$ssn'");
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
        ? "DELETE FROM water WHERE id='${date.day}.${date.month}${localSource.getSSN()}' AND ssn = '${localSource.getSSN()}'"
        : amount == 1 && dailyWaterAmount == 0
            ? "INSERT INTO water(id, amount, ssn) VALUES ('${date.day}.${date.month}${localSource.getSSN()}','$amount','${localSource.getSSN()}')"
            : "UPDATE water SET amount='$amount' WHERE ssn = '${localSource.getSSN()}'");
    dailyWaterAmount = amount;
    update();
  }

  void changeNavBar(int index) async {
    navBarIndex = index;
    if (index == 1) {
      await getOtherWorkouts();
      await getInjuries();
    }
    update();
  }

  Future<void> signUp(UserModel user, String password) async {
    await connectionPool
        ?.execute(
            "INSERT INTO person (`ssn`, `name_fname`, `name_lname`, `email`, `password`) VALUES ('${user.ssn}','${user.firstName}','${user.lastName}','${user.email}','$password')")
        .then(
      (value) async {
        await connectionPool
            ?.execute(
                "INSERT INTO user (`height`, `weight`, `date_of_birth`, `ssn`, `age`) VALUES ('${user.height}','${user.weight}','${user.dateOfBirth}','${user.ssn}','${user.age}')")
            .then(
          (value) async {
            await getUserData(user.ssn).then((v) async {
              await getUserWorkout(user.ssn);
              await getDailyWaterConsumption(user.ssn);
              await getSleepDuration(user.ssn);
            });
            await localSource.setProfile(userData?.ssn ?? '').then(
              (value) {
                Get.offAllNamed(Constants.mainR);
              },
            );
          },
        );
      },
    );
  }

  Future<void> getExercises(String workoutId) async {
    exercises = [];
    IResultSet? result = await connectionPool?.execute(
        "SELECT title FROM exercise JOIN workout_exercise USING(exercise_id) WHERE workout_exercise.id = '$workoutId'");
    if ((result?.rows ?? []).isNotEmpty) {
      (result?.rows ?? []).forEach(
        (exer) {
          if ((exer.colAt(0) ?? '').isNotEmpty) {
            exercises.add(exer.colAt(0) ?? '');
          }
        },
      );
    }
    await getEquipments(workoutId);
    update();
  }

  Future<void> registerWorkout(String workoutId) async {
    var ssn = localSource.getSSN();
    await connectionPool
        ?.execute("UPDATE user SET id='$workoutId' WHERE ssn = '$ssn'")
        .then((value) async {
      await getUserData(ssn).then((v) async {
        await getUserWorkout(ssn);
        await getDailyWaterConsumption(ssn);
        await getSleepDuration(ssn);
      });
    });
  }

  Future<void> getEquipments(String workoutId) async {
    equipments = [];
    IResultSet? result = await connectionPool?.execute(
        "SELECT equipment.name, equipment.description FROM equipment JOIN workout_workout_equipment USING(equipment_id) WHERE workout_workout_equipment.id = '$workoutId'");
    if ((result?.rows ?? []).isNotEmpty) {
      (result?.rows ?? []).forEach(
        (exer) {
          if ((exer.colAt(0) ?? '').isNotEmpty) {
            equipments.add(EquipmentModel(
                name: exer.colAt(0) ?? '', description: exer.colAt(1) ?? ''));
          }
        },
      );
    }
    update();
  }

  Future<void> login(String email, String password) async {
    IResultSet? result = await connectionPool?.execute(
        "SELECT * FROM person WHERE email = '$email' AND password = '$password'");
    if ((result?.rows ?? []).isNotEmpty) {
      IResultSet? result2 = await connectionPool?.execute(
          "SELECT * FROM user JOIN person USING(ssn) WHERE user.ssn='${result?.rows.first.colAt(0) ?? ''}'");
      if ((result2?.rows ?? []).isNotEmpty) {
        getUserData(result?.rows.first.colAt(0) ?? '').then(
          (value) async {
            await getUserData(result?.rows.first.colAt(0) ?? '')
                .then((v) async {
              await getUserWorkout(result?.rows.first.colAt(0) ?? '');
              await getDailyWaterConsumption(result?.rows.first.colAt(0) ?? '');
              await getSleepDuration(result?.rows.first.colAt(0) ?? '');
            });
            await localSource.setProfile(userData?.ssn ?? '').then(
              (value) {
                Get.offAllNamed(Constants.mainR);
              },
            );
          },
        );
      }
    }
  }

  Future<void> updateProfile({
    required double weight,
    required double height,
    required DateTime birthdate,
  }) async {
    await connectionPool
        ?.execute(
            "UPDATE user SET height='$height', weight='$weight', date_of_birth='$birthdate' WHERE ssn='${localSource.getSSN()}'")
        .then((value) async {
      await getUserData(localSource.getSSN()).then((v) async {
        await getUserWorkout(localSource.getSSN());
        await getDailyWaterConsumption(localSource.getSSN());
        await getSleepDuration(localSource.getSSN());
      });
    });
  }

  Future<void> logout() async {
    await localSource
        .logout()
        .then((value) => Get.offAllNamed(Constants.authR));
  }
}
