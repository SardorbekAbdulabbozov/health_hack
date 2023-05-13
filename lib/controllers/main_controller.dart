import 'package:health_hack/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysql_client/mysql_client.dart';

class MainController extends GetxController {
  MySQLConnection? connectionPool;
  String data = '';
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
  }

  Future<void> getData(String tableName, bool all) async {
    IResultSet? result =
        await connectionPool?.execute('SELECT * FROM $tableName');
    data = '${result?.rows.first.colAt(1)}';
    update();
  }

  void changeNavBar(int index){
    navBarIndex=index;
    update();
  }
}
