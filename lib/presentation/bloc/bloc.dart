import 'dart:async';

import 'package:blackout_tracker/data/remote/fire_store.dart';
import 'package:blackout_tracker/domain/entities/constants.dart';
import 'package:blackout_tracker/domain/entities/data_model.dart';
import 'package:blackout_tracker/domain/usecases/info_checker.dart';
import 'package:blackout_tracker/presentation/bloc/events.dart';
import 'package:blackout_tracker/presentation/bloc/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:workmanager/workmanager.dart';

class MainBloc extends Bloc<ListEvent, ListState> {
  Box<DataModel> blackBox = Hive.box(dataBoxName);

  MainBloc() : super(ListInitState()) {
    on<GetEvent>(getEvent);
    on<UpdateEvent>(getInfoEvent);
    on<DeleteElementEvent>(deleteEvent);
    on<ReloadWorkManager>(reloadWorkmanager);
    on<ReadCloud>(readCloud);
  }

  Future<void> getEvent(GetEvent element, Emitter<ListState> emitter) async {
    //Update List
    final List<DataModel> dataList = blackBox.values.toList();
    emitter(UpdateUiState(dataList));
    //Run background process
    Workmanager().registerPeriodicTask(
      workerName,
      workerName,
      frequency: const Duration(hours: 1),
      existingWorkPolicy: ExistingWorkPolicy.keep,
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(seconds: 10),
      initialDelay: const Duration(seconds: 5),
    );

    //Trigger UI update if a background process updates Box
    while (true) {
      await Future.delayed(const Duration(seconds: 10));
      final Box<int> workBox = await Hive.openBox<int>(workBoxName);
      final updatedBox = workBox.get(workBoxKey);
      if (updatedBox != null && updatedBox == 1) {
        try {
          await blackBox.close();
        } catch (_) {
          //if blackBox is closed
        }
        blackBox = await Hive.openBox<DataModel>(dataBoxName);
        final List<DataModel> dataList = blackBox.values.toList();
        emitter(UpdateUiState(dataList));
        await workBox.put(workBoxKey, 0);
      }
      try {
        await workBox.close();
      } catch (_) {
        //if workBox is closed
      }
    }
  }

  Future<void> getInfoEvent(
    UpdateEvent event,
    Emitter<ListState> emitter,
  ) async {
    //Check and save info
    final DataModel infoResult = await getInfo(id: blackBox.keys.length);
    await blackBox.put(infoResult.id, infoResult);
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
    final List<DataModel> dataList = blackBox.values.toList();
    emitter(UpdateUiState(dataList));
  }

  Future<void> deleteEvent(
    DeleteElementEvent element,
    Emitter<ListState> emitter,
  ) async {
    await blackBox.delete(element.index);
    final List<DataModel> dataList = blackBox.values.toList();
    emitter(UpdateUiState(dataList));
  }

  Future<void> readCloud(
    ReadCloud element,
    Emitter<ListState> emitter,
  ) async {
    await readFromCloud().then((dataList) => emitter(ReadCloudState(dataList)));
  }

  Future<void> reloadWorkmanager(
    ReloadWorkManager element,
    Emitter<ListState> emitter,
  ) async {
    Workmanager().registerPeriodicTask(
      workerName,
      workerName,
      frequency: const Duration(hours: 1),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(seconds: 10),
      initialDelay: const Duration(seconds: 5),
    );
  }
}
