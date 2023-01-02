import 'package:blackout_tracker/data/local/hive_datatype_adapter.dart';
import 'package:blackout_tracker/data/remote/fire_store.dart';
import 'package:blackout_tracker/domain/entities/constants.dart';
import 'package:blackout_tracker/domain/entities/data_model.dart';
import 'package:blackout_tracker/domain/entities/firebase_options.dart';
import 'package:blackout_tracker/domain/usecases/info_checker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:workmanager/workmanager.dart';

@pragma(
  'vm:entry-point',
) // Mandatory if the App is obfuscated or using Flutter 3.1+
Future<void> callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    if (task == workerName) {
      // Ensure that plugin services are initialized
      WidgetsFlutterBinding.ensureInitialized();
      // Initialize Hive
      await Hive.initFlutter();
      Hive.registerAdapter(DataModelAdapter());
      // Initialize Firebase
      await Firebase.initializeApp(
        name: 'workmanager',
        options: firebaseOptions,
      );
      //Check and save mobile info
      final Box<DataModel> blackBox = await Hive.openBox(dataBoxName);
      final DataModel infoResult = await getInfo(id: blackBox.keys.length);
      await blackBox.put(infoResult.id, infoResult);
      // Save worker state
      final Box<int> workBox = await Hive.openBox(workBoxName);
      await workBox.put(workBoxKey, 1);
      // Send to Cloud
      if (infoResult.internetConnect == true) {
        for (final DataModel elem in blackBox.values) {
          if (elem.cloudArchive == false) {
            elem.cloudArchive = true;
            blackBox.put(elem.id, elem);
            await addToCloud(elem.toMap());
          }
        }
      }
      await blackBox.close();

      return Future.value(true); // Task will be emitted here.
    }

    return Future.value(false);
  });
}
