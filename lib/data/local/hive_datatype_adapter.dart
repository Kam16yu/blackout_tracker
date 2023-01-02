import 'package:blackout_tracker/domain/entities/data_model.dart';
import 'package:hive_flutter/adapters.dart';

//Adapter for Hive, read and save DataModel class objects as Hive objects
class DataModelAdapter extends TypeAdapter<DataModel> {
  @override
  final int typeId = 5;

  @override
  DataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return DataModel(
      time: fields[0] as DateTime?,
      chargeState: fields[1] as String?,
      chargeLevel: fields[2] as int?,
      wifiConnect: fields[3] as bool?,
      internetConnect: fields[4] as bool?,
      id: fields[5] as int?,
      cloudArchive: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, DataModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.chargeState)
      ..writeByte(2)
      ..write(obj.chargeLevel)
      ..writeByte(3)
      ..write(obj.wifiConnect)
      ..writeByte(4)
      ..write(obj.internetConnect)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.cloudArchive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
