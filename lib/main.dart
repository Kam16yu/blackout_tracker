import 'package:blackout_tracker/data/local/hive_datatype_adapter.dart';
import 'package:blackout_tracker/domain/entities/constants.dart';
import 'package:blackout_tracker/domain/entities/data_model.dart';
import 'package:blackout_tracker/domain/entities/firebase_options.dart';
import 'package:blackout_tracker/domain/usecases/work_manager.dart';
import 'package:blackout_tracker/presentation/bloc/bloc.dart';
import 'package:blackout_tracker/presentation/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  // Ensure that plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();
  //Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(DataModelAdapter());
  await Hive.openBox<DataModel>(dataBoxName);
  await Hive.openBox<int>(workBoxName);
  //Initialize Firebase
  await Firebase.initializeApp(name: 'main', options: firebaseOptions);
  //Initialize Workmanager
  await Workmanager().initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    isInDebugMode:
        true, // If enabled it will post a notification whenever the task is
    // running. Handy for debugging tasks
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter blackout checker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter blackout checker'),
      ),
      //Implementing Bloc in app
      body: BlocProvider(
        create: (context) => MainBloc(),
        child: const InfoPage(),
      ),
    );
  }
}
