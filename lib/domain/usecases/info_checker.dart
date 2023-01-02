import 'dart:async';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:blackout_tracker/domain/entities/data_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectCheck {
  //Singleton of ConnectCheck()
  ConnectCheck._();

  static final _instance = ConnectCheck._();

  static ConnectCheck get instance => _instance;

  //Get instance of Connectivity()
  static final _connectivity = Connectivity();

  // Info about WiFI using and cellular data
  Future<ConnectivityResult> checkConnects() async {
    return _connectivity.checkConnectivity();
  }

  //Checking internet connection
  Future<bool> internetConnect() async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }

    return isOnline;
  }
}

class BatteryStats {
  //Singleton of BatteryStats()
  BatteryStats._();

  static final _instance = BatteryStats._();

  static BatteryStats get instance => _instance;

  //Get instance of Battery()
  static final Battery _battery = Battery();

  //Get info about battery Level
  Future<int> chargeLevel() {
    return _battery.batteryLevel;
  }

  //Get info about power state - charging/discharging
  Future<BatteryState> chargeState() {
    return _battery.batteryState;
  }
}

Future<DataModel> getInfo({int id = 0}) async {
  // Get instances
  final battery = BatteryStats.instance;
  final connect = ConnectCheck.instance;
  //Get battery and connect info
  final List value = await Future.wait([
    battery.chargeState(),
    battery.chargeLevel(),
    connect.checkConnects(),
    connect.internetConnect(),
  ]);
  // Get battery State
  value[0] = value[0].toString().split('.')[1];
  // Setting WiFi State
  if (value[2] != ConnectivityResult.wifi) {
    value[2] = false;
  } else {
    value[2] = true;
  }

  final DataModel result = DataModel(
    time: DateTime.now(),
    chargeState: value[0] as String,
    chargeLevel: value[1] as int,
    wifiConnect: value[2] as bool,
    internetConnect: value[3] as bool,
    id: id + 1,
    cloudArchive: false,
  );

  return result;
}
