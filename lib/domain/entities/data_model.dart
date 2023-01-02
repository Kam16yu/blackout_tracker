import 'package:hive/hive.dart';

//DataModel class with Hive datatype adapter annotations
@HiveType(typeId: 5)
class DataModel {
  @HiveField(0)
  final DateTime? time;
  @HiveField(1)
  final String? chargeState;
  @HiveField(2)
  final int? chargeLevel;
  @HiveField(3)
  final bool? wifiConnect;
  @HiveField(4)
  final bool? internetConnect;
  @HiveField(5)
  final int? id;
  @HiveField(6)
  bool? cloudArchive;

  DataModel({
    required this.time,
    required this.chargeState,
    required this.chargeLevel,
    required this.wifiConnect,
    required this.internetConnect,
    required this.id,
    required this.cloudArchive,
  });

  //Constructor from map
  DataModel.fromMap(Map<String, dynamic> map)
      : time = map["time"] as DateTime?,
        chargeState = map["chargeState"] as String?,
        chargeLevel = map["chargeLevel"] as int?,
        wifiConnect = map["wifiConnect"] as bool?,
        internetConnect = map["internetConnect"] as bool?,
        id = map["id"] as int?,
        cloudArchive = map["cloudArchive"] as bool?;

  Map<String, dynamic> toMap() => {
        "time": time,
        "chargeState": chargeState,
        "chargeLevel": chargeLevel,
        "wifiConnect": wifiConnect,
        "internetConnect": internetConnect,
        "id": id,
        "cloudArchive": cloudArchive,
      };
}
